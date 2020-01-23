# dotfile.mk - generate and install customizable dotfiles
# Copyright (C) 2017 Benjamin Abendroth
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# =============================================================================
# Dotfile Makefile v. 0.1
# =============================================================================

# Variables that should not be used outside this Makefile should be
# prefixed with an underscore. (Underscored variables don't show up
# in shell completion)
#
# Documentation that can be retrieved with 'make help-variables' must
# be prefixed with "#$".
#
# Documentation that can be retrieved with 'make help-commands' must
# be prefixed with "#!".

# Parameters for building/installing an dotfile package
# =============================================================================
TMPDIR ?= /tmp

#$ ROOT_DIR
#$  Output destination for 'make install'.
ROOT_DIR ?= $(HOME)

#$ BUILD_DIR
#$  Output destination for 'make build'.
BUILD_DIR ?= $(TMPDIR)/dotfiles-$(USER)

#$ PRIVATE_DIR
#$  Directory to retrieve private information from inside preprocessor-files.
PRIVATE_DIR ?= 

#$ PREFIX_DIR
#$  Prefix directory, use this to place files in a ~/.subdirectory/
ifndef PREFIX_DIR
FILE_PREFIX := .
else
FILE_PREFIX :=
endif

# Filepp defaults
# =============================================================================

#$ FILEPP
#$  Name of the 'filepp' binary
FILEPP 			?= filepp

#$ FILEPP_PREFIX
#$  Prefix for recognizing preprocessor directives. Option '-kc'
FILEPP_PREFIX 	?= \#>

#$ FILEPP_MODULES
#$  Modules to use in filepp
FILEPP_MODULES ?=

#$ FILEPP_MODULE_DIRS
#$  List of directories to search for filepp modules
FILEPP_MODULE_DIRS ?=

#$ FILEPP_INCLUDE
#$  Include directory for filepp
FILEPP_INCLUDE ?=

#$ FILEPP_FLAGS
#$  Custom filepp flags
FILEPP_FLAGS	?=

#$ IGNORE_FILES
#$  Ignore these files when auto generating file list
IGNORE_FILES ?=

# File selection variables
# =============================================================================

#$ FILES
#$  File that should be copied
FILES ?=

#$ PP_FILES
#$  Files that should be passed to the preprocessor
PP_FILES ?= 

#$ DIRECTORIES
#$  Additional directories to be created
DIRECTORIES ?=

# Special defines
# =============================================================================

ifeq ($(HOST), )
HOST := $(shell hostname)
endif

ifeq ($(OPERATING_SYSTEM), )
OPERATING_SYSTEM := $(shell uname -s)
endif

# Parameters end here, new variables below this line should be
# prefixed with an underscore.
# =============================================================================

_MAKE_PROG := $(notdir $(MAKE))
_DOTFILE_MK := $(realpath $(filter %dotfile.mk, $(MAKEFILE_LIST)))
_PACKAGES_ROOT := $(dir $(_DOTFILE_MK))
_PACKAGE_PATH := $(realpath .)
_PACKAGE_NAME := $(notdir $(_PACKAGE_PATH))
_PACKAGE_BUILD_DIR := $(BUILD_DIR)/$(_PACKAGE_NAME)

# A directory that can be used for temp files in the build process
_TEMP_DIR := $(BUILD_DIR)/$(_PACKAGE_NAME)-temp

# Adjust PATH for using locally installed filepp
PATH := $(PATH):$(_PACKAGES_ROOT)/.filepp/bin
export PATH

# Collect the defines in Makefile, create a list of -D<defines>
# =============================================================================

# Additional variables that should be passed to preprocessor
_ADDITIONAL_DEFINES := HOST OPERATING_SYSTEM PRIVATE_DIR _TEMP_DIR \
								_PACKAGE_NAME _PACKAGE_PATH _PACKAGE_BUILD_DIR

# Ignore these variables found in Makfile
_IGNORE_VARS := FILES PP_FILES IGNORE_FILES \
	ROOT_DIR BUILD_DIR PRIVATE_DIR PREFIX_DIR FILE_PREFIX \
	FILEPP FILEPP_PREFIX FILEPP_MODULES FILEPP_INCLUDE FILEPP_FLAGS
_CONFIG_VARS := $(shell sed -n -E \
	's/^([a-zA-Z0-9][a-zA-Z0-9_]+)[[:space:]]*[:\+\?]?=.*/\1/p' \
	$(filter-out %dotfile.mk, $(MAKEFILE_LIST)) )
_CONFIG_VARS := $(sort $(_CONFIG_VARS)) # deduplicate variables
_CONFIG_VARS := $(filter-out $(_IGNORE_VARS), $(_CONFIG_VARS))
_DEFINED_VARS := $(_CONFIG_VARS) $(_ADDITIONAL_DEFINES)

_FILEPP_DEFINES := $(foreach V, $(_DEFINED_VARS), "-D$V=$($V)")
_FILEPP_MODULES := $(addprefix -m , $(FILEPP_MODULES))
_FILEPP_MODULE_DIRS := \
	$(addprefix -M, $(_PACKAGES_ROOT)/.filepp_modules $(FILEPP_MODULE_DIRS) )

# Important: _PACKAGE_BUILD_DIR precedes other include dirs
_FILEPP_INCLUDE := -I$(_PACKAGE_BUILD_DIR)
#ifneq ($(PRIVATE_DIR), )
#_FILEPP_INCLUDE += -I$(PRIVATE_DIR)
#endif #XXX
_FILEPP_INCLUDE += $(addprefix -I, $(FILEPP_INCLUDE))


# File-selection logic starts here
# =============================================================================

# We NEVER want these files (BUILD_DIR could also be inside package dir)
_FORCE_IGNORE := $(MAKEFILE_LIST) $(BUILD_DIR) $(BUILD_DIR)/%

# If neither FILES nor PP_FILES is given, auto generate file-list
ifeq ($(FILES), )
ifeq ($(PP_FILES), )
PP_FILES := $(shell find . -mindepth 1 -type f -name '*.pp')
FILES := $(shell find . -mindepth 1 -type f -not -name '*.pp')
endif
endif

# Repair paths
FILES := $(subst $(_PACKAGE_PATH)/,, $(realpath $(FILES)))
PP_FILES := $(subst $(_PACKAGE_PATH)/,, $(realpath $(PP_FILES)))

# Remove ignored files
FILES := $(filter-out $(_FORCE_IGNORE) $(IGNORE_FILES), $(FILES))
PP_FILES := $(filter-out $(_FORCE_IGNORE) $(IGNORE_FILES), $(PP_FILES))

# Get the list of directories
DIRECTORIES += $(subst ./,, $(dir $(FILES) $(PP_FILES)))
DIRECTORIES := $(sort $(DIRECTORIES))

# We export these variables for calling shell scripts
# =============================================================================
#export ROOT_DIR BUILD_DIR PRIVATE_DIR PREFIX_DIR FILE_PREFIX
#export FILEPP FILEPP_PREFIX FILEPP_INCLUDE FILEPP_MODULES FILEPP_FLAGS
#export FILES PP_FILES DIRECTORIES IGNORE_FILES
export $(_DEFINED_VARS)

# Makefile rules start here
# =============================================================================

.DEFAULT_GOAL := build

# This target must not be overriden, but it should preceed each makefile that
# overrides other targets (.pre_build, .post_build).
build:: .check_dependencies clean $(_PACKAGE_BUILD_DIR) $(_TEMP_DIR) \
			.pre_build .build_msg $(DIRECTORIES) $(FILES) $(PP_FILES) \
			.post_build 
.build_msg:
	@echo '> Starting build ...'

# These targets can be overriden
.pre_build:: .pre_build_msg
.pre_build_msg:
	@echo '> Entering pre_build hook ...'

.post_build:: .post_build_msg
.post_build_msg:
	@echo '> Entering post_build hook ...'

.pre_install:: .pre_install_msg
.pre_install_msg:
	@echo '> Entering pre_install hook ...'

.post_install:: .post_install_msg
.post_install_msg:
	@echo '> Entering post_install hook ...'

# Create the build directory for package
$(_PACKAGE_BUILD_DIR):
	@mkdir -p -- "$@"

# Create the temp directory
$(_TEMP_DIR):
	@mkdir -p -- "$@"

# Create directories
$(DIRECTORIES): .force
	@mkdir -p -v -- "$(_PACKAGE_BUILD_DIR)/$@"

# Copy files
$(FILES): .force
	@cp -v -p -- "$@" "$(_PACKAGE_BUILD_DIR)/$@"

# Generate files 
$(PP_FILES): .force
	@echo ">> Preprocessing $@ ..."
	@$(FILEPP) \
		$(_FILEPP_DEFINES) \
		$(_FILEPP_MODULE_DIRS) $(_FILEPP_MODULES) \
		$(_FILEPP_INCLUDE) \
		-kc "$(FILEPP_PREFIX)" \
		-ec "ENVIRONMENT." -e \
		$(FILEPP_FLAGS) "$@" -o "$(_PACKAGE_BUILD_DIR)/$(subst .pp,,$@)"

# Shell code for changing to _PACKAGE_BUILD_DIR
.CD_TO_BUILD_DIR = \
	cd "$(_PACKAGE_BUILD_DIR)" || { \
		echo "Did you run '$(_MAKE_PROG) build' yet?"; \
		exit 1; \
	};

#! check_dependencies
#!  Check if all dependencies are installed
check_dependencies: .check_dependencies

.SILENT:
.check_dependencies::
	echo -n "Checking for filepp ... "
	echo X | "$(FILEPP)" -DX="found" -c || { \
		echo "Filepp binary '$(FILEPP)' not found."; \
		echo "Please install it with your package-manager."; \
		echo "Alternatively you can run $(_PACKAGES_ROOT)/.filepp/install_on_system.sh for a system-wide installation"; \
		echo "or $(_PACKAGES_ROOT)/.filepp/install_locally.sh for an installation inside your dotfile-folder."; \
		false; \
	}
	for M in $(FILEPP_MODULES); do \
		echo -n "Checking for filepp module $$M ... "; \
		echo OK | "$(FILEPP)" -c $(_FILEPP_MODULE_DIRS) -m $$M || exit 1; \
	done

#! install
#!  Copy files from build-dir to root-dir
install: .pre_install .install .post_install

.install::
	mkdir -p -- "$(ROOT_DIR)/$(PREFIX_DIR)"
	
	$(.CD_TO_BUILD_DIR) \
	\
	find . -mindepth 1 -type d | sed 's|^./||' | while read -r D; do \
		mkdir -p -- "$(ROOT_DIR)/$(PREFIX_DIR)/$(FILE_PREFIX)$$D"; \
	done; \
	\
	find . -mindepth 1 -type f | sed 's|^./||' | while read -r F; do \
		if ! cmp -- \
			"$$F" "$(ROOT_DIR)/$(PREFIX_DIR)/$(FILE_PREFIX)$$F" &>/dev/null; \
		then \
			cp -v -p -- "$$F" "$(ROOT_DIR)/$(PREFIX_DIR)/$(FILE_PREFIX)$$F"; \
		fi; \
	done;
	
# Check if diff supports color
_DIFF_PROGRAM = diff 
_DIFF_COLOR = $(shell diff --help 2>&1 | grep -q -- --color && echo --color=always)

#! diff
#!  Show the difference between newly generated files in the build directory
#!  and the old files in the root directory.
diff: .force
	$(.CD_TO_BUILD_DIR) \
	find . -mindepth 1 -type f | sed 's|^./||' | while read -r F; do \
		if [ -e "$(ROOT_DIR)/$(PREFIX_DIR)/$(FILE_PREFIX)$$F" ]; then \
			$(_DIFF_PROGRAM) $(_DIFF_COLOR) -- \
			"$(ROOT_DIR)/$(PREFIX_DIR)/$(FILE_PREFIX)$$F" "$$F" || \
				echo " ^--- in $$F"; \
		else \
			echo "$$F missing in $(ROOT_DIR)"; \
		fi; \
	done

#! cat
#!  Cat build files
cat: .force
	$(.CD_TO_BUILD_DIR) \
	find . -mindepth 1 -type f -print -exec cat -n {} \;

#! info
#!  Show a list of configuration variables in Makefile
info:
	$(foreach V, $(_CONFIG_VARS), \
		$(info $V = $(value $V)) \
	)

#! help
#!  Show help summary
help:
	@echo "Usage: $(_MAKE_PROG) build|clean|cat|diff|info|install"
	@echo	
	@echo "See '$(_MAKE_PROG) help-variables' or '$(_MAKE_PROG) help-commands' for more help."

#! help-variables
#!  Show help for variables
help-variables:
	@grep -h '^#\$$' -- $(_DOTFILE_MK) | \
		sed -E -e 's/^#.//' -e 's/^ ([^ ])/\n\1/g'

#! help-commands
#!  Show help for commands
help-commands:
	@grep -h '^#!' -- $(_DOTFILE_MK) | \
		sed -E -e 's/^#.//' -e 's/^ ([^ ])/\n\1/g'

#! clean
#!  Remove the build dir
clean: clean-temp
	rm -rf -- "$(_PACKAGE_BUILD_DIR)"

clean-build-dir:
	rmdir -- "$(BUILD_DIR)"

clean-temp:
	rm -rf -- "$(_TEMP_DIR)"

.force:
	# we use this to force building a target
	
# vim: noexpandtab:shiftwidth=3:tabstop=3:softtabstop=3:textwidth=80
