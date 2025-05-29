#!/usr/bin/python3

import os
import sys
import stat
import yaml
import shlex
import shutil
import argparse
from contextlib import contextmanager
from collections import OrderedDict

# =============================================================================
# Helper functions
# =============================================================================

class DotException(Exception):
    pass

def make_executable(file):
    mode = os.stat(file).st_mode
    os.chmod(file, mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)

def indent(string, num_spaces):
    lines = string.split('\n')
    indented_lines = [((' ' * num_spaces) + line) if line.strip() else line for line in lines]
    return '\n'.join(indented_lines)

@contextmanager
def chdir(directory):
    old_dir = os.getcwd()

    try:
        os.chdir(directory)
        yield
    finally:
        os.chdir(old_dir)

def get_all_files(directory):
    r = []

    for dirpath, dirnames, filenames in os.walk(directory):
        for filename in filenames:
            file = os.path.join(dirpath, filename)
            if file.startswith('./'):
                file = file[2:]

            r.append(file)

    return r

def get_preprocessed_output_name(file):
    return file.replace('.pp', '') # TODO

class Log:
    @staticmethod
    def info(*args):
        print('INFO:', *args, file=sys.stderr)

    @staticmethod
    def verbose(*args):
        print('VERBOSE:', *args, file=sys.stderr)

    @staticmethod
    def error(*args):
        print('ERROR:', *args, file=sys.stderr)

class Package:
    ALIASES = {
        'filepp_modules':           'preprocessor_modules',
        'filepp_prefix':            'preprocessor_prefix',
        'filepp_include_dirs':      'preprocessor_include_dirs',
        'pp_files':                 'preprocessor_files',
    }

    STRING_FIELDS = [
        'pre_build',    'post_build',
        'post_install',
        'apply',
        'prefix_dir',
        'preprocessor_prefix',
        'preprocessor_environment_prefix',
    ]

    LIST_OF_STRING_FIELDS = [
        'preprocessor_include_dirs',
        'preprocessor_modules',
        'ignore_files',
        'directories', # TODO
    ]

    def __init__(self, file):
        try:
            with open(file, 'r', encoding='UTF-8') as fh:
                content = fh.read()

            if not content.strip():
                self.data = {}
                return

            with open(file, 'r', encoding='UTF-8') as fh:
                self.data = yaml.safe_load(fh)
        except FileNotFoundError:
            self.data = {}
        except Exception as e:
            raise DotException(f'Could not read {file}: {e}')

        try:
            self.validate()
        except DotException as e:
            raise DotException(f'{file}: {e}')

    def validate(self):
        if not isinstance(self.data, dict):
            raise DotException('Package YAML is not a dict')

        for key in list(self.data.keys()):
            if key in Package.ALIASES:
                new_key = Package.ALIASES[key]
                self.data[new_key] = self.data.pop(key)

        for key, value in self.data.items():
            if key in Package.STRING_FIELDS:
                if not isinstance(value, str):
                    raise DotException(f'{key}: Invalid type (expected string)')

            elif key in Package.LIST_OF_STRING_FIELDS:
                if not isinstance(value, list):
                    raise DotException(f'{key}: Invalid type (expected list)')

                for i, sub_value in enumerate(value):
                    if not isinstance(sub_value, str):
                        raise DotException(f'{key}[{i}]: Invalid type (expected string)')

            elif key == 'defines':
                if not isinstance(value, dict):
                    raise DotException(f'{key}: Invalid type (expected dictionary)')

                for sub_key, sub_value in value.items():
                    if not isinstance(sub_key, str):
                        raise DotException(f'{key}: {sub_key}: Invalid type (expected string)')

                    if not isinstance(sub_value, str):
                        raise DotException(f'{key}: {sub_key}: Invalid type (expected string)')

            elif key in ('files', 'preprocessor_files'):
                if isinstance(value, list):
                    for i, sub_value in enumerate(value):
                        if not isinstance(sub_value, str):
                            raise DotException(f'{key}[{i}]: Invalid type (expected string)')

                elif isinstance(value, dict):
                    for sub_key, sub_value in value.items():
                        if not isinstance(sub_key, str):
                            raise DotException(f'{key}: {sub_key}: Invalid type (expected string)')

                        if not isinstance(sub_value, str):
                            raise DotException(f'{key}: {sub_key}: Invalid type (expected string)')

                else:
                    raise DotException(f'{key}: Invalid type (expected list or dictionary)')

            else:
                raise DotException(f'{key}: Invalid option')

    # =========================================================================
    # Pre/Post Build/Install
    # =========================================================================

    def get_pre_build(self):
        return self.data.get('pre_build', None)

    def get_post_build(self):
        return self.data.get('post_build', None)

    def get_post_install(self):
        return self.data.get('post_install', None)

    def get_apply(self):
        return self.data.get('apply', None)

    # =========================================================================
    # PreProcessor Options
    # =========================================================================

    def get_defines(self):
        return self.data.get('defines', {})

    def get_preprocessor_prefix(self):
        return self.data.get('preprocessor_prefix', '#>')

    def get_preprocessor_modules(self):
        return self.data.get('preprocessor_modules', [])

    def get_preprocessor_include_dirs(self):
        return self.data.get('preprocessor_include_dirs', [])

    def get_preprocessor_enviroment_prefix(self):
        return self.data.get('preprocessor_environment_prefix', 'ENVIRONMENT.')

    # =========================================================================
    # Input files
    # =========================================================================

    def get_prefix_dir(self):
        return self.data.get('prefix_dir', None)

    def get_ignore_files(self):
        return self.data.get('ignore_files', [])

    def get_preprocessor_files(self):
        if 'preprocessor_files' in self.data:
            return self.data['preprocessor_files']

        if 'files' in self.data:
            return []

        r = []

        for file in get_all_files('.'):
            if file.endswith('.pp') or '.pp.' in file:
                r.append(file)

        return r

    def get_files(self):
        if 'files' in self.data:
            return self.data['files']

        if 'preprocessor_files' in self.data:
            return []

        files        = get_all_files('.')
        pp_files     = self.get_preprocessor_files()
        ignore_files = self.get_ignore_files()
        ignore_files.extend(['package.yaml', 'package.sh', '.filepp_modules'])

        for file in pp_files:
            try:
                files.remove(file)
            except ValueError:
                pass

        for file in list(files):
            if file in ignore_files:
                files.remove(file)
            else: # TODO
                for ignore_file in ignore_files:
                    if file.startswith(ignore_file):
                        files.remove(file)
                        break

        return files

    # =========================================================================
    # Other functions
    # =========================================================================

    class File:
        def __init__(self, input_file, output_file):
            self.input_file = input_file
            self.output_file = output_file

        def remove_preprocessor_extension(self):
            self.output_file = get_preprocessed_output_name(self.output_file)

        def get_output_directory(self):
            if '/' in self.output_file:
                return self.output_file.rsplit('/', maxsplit=1)[0]
            else:
                return ''

    def get_files_with_install_location(self, files):
        prefix_dir = self.get_prefix_dir()
        r = []

        if prefix_dir is not None:
            for input_file in files:
                output_file = os.path.join(prefix_dir, input_file)
                r.append(Package.File(input_file, output_file))
        else:
            for input_file in files:
                output_file = f'.{input_file}'
                r.append(Package.File(input_file, output_file))

        return r

    def get_files_with_prefix(self):
        files = self.get_files()

        if isinstance(files, list):
            return self.get_files_with_install_location(files)
        else:
            r = []
            for output_file, input_file in files.items():
                r.append(Package.File(input_file, output_file))
            return r

    def get_pp_files_with_prefix(self):
        files = self.get_preprocessor_files()

        if isinstance(files, list):
            return self.get_files_with_install_location(files)
        else:
            r = []
            for output_file, input_file in files.items():
                r.append(Package.File(input_file, output_file))
            return r

class PreProcessor:
    def __init__(self):
        self.program = None
        self.defines = {}
        self.modules = []
        self.module_dirs = []
        self.include_dirs = []
        self.prefix = None
        self.environment_prefix = None
        self.flags = []
        self.input_file = None
        self.output_file = None

    def set_program(self, program):
        self.program = program

    def set_output_file(self, file):
        self.output_file = file

    def set_input_file(self, file):
        self.input_file = file

    def add_define(self, name, value):
        self.defines[name] = value

    def add_defines(self, defines):
        for name, value in defines.items():
            self.add_define(name, value)

    def add_module(self, module):
        self.modules.append(module)

    def add_modules(self, modules):
        for module in modules:
            self.add_module(module)

    def add_module_dir(self, directory):
        self.module_dirs.append(directory)

    def add_module_dirs(self, directories):
        for directory in directories:
            self.add_module_dir(directory)

    def add_include_dir(self, directory):
        self.include_dirs.append(directory)

    def add_include_dirs(self, directories):
        for directory in directories:
            self.add_include_dir(directory)

    def set_flags(self, flags):
        self.flags = flags

    def set_prefix(self, prefix):
        self.prefix = prefix

    def set_environment_prefix(self, prefix):
        self.environment_prefix = prefix

    def get_args(self):
        args = [self.program]

        for name, value in self.defines.items():
            args += [f'-D{name}={value}']

        for directory in self.module_dirs:
            args += [f'-M{directory}']

        for module in self.modules:
            args += ['-m', module]

        for directory in self.include_dirs:
            args += [f'-I{directory}']

        if self.prefix is not None:
            args += ['-kc', self.prefix]

        if self.environment_prefix is not None:
            args += ['-ec', self.environment_prefix]

        if self.flags:
            args += flags

        if self.input_file:
            args += [self.input_file]

        if self.output_file:
            args += ['-o', self.output_file]

        return args

class PackageSh:
    SCRIPT_START = '''\
#!/bin/sh

set -e

cd "$(dirname "$0")"

PACKAGE="%PACKAGE%"

export TEMP_DIR="${TMPDIR:-${TEMP:-${TMP:-/tmp}}}"
export BUILD_DIR="$TEMP_DIR/dotfiles-$USER/$PACKAGE"
export DEST_DIR="${DEST_DIR:-$HOME}"

FILEPP_DIR="$TEMP_DIR/filepp-$USER"
FILEPP="$FILEPP_DIR/bin/filepp"
DIFF="${DIFF:-diff}"\
'''

    SCRIPT_END = '''\
cmd_help() {
  cat << EOF
Usage: $0 {build|clean|diff|install|show|help}

apply:
  Apply configurations

build:
  Build the current package

clean:
  Remove the build directory

diff:
  Diff the builded package

install:
  Install the builded package

show:
  Show configuration variables
EOF
}

get_filepp() {
  [ -x "$FILEPP" ] && return

  OLDPWD="$PWD"

  mkdir -p "$FILEPP_DIR"

  cd "$FILEPP_DIR"

  FILEPP_VERSION="1.8.0"
  FILEPP_TAR_GZ="filepp-$FILEPP_VERSION.tar.gz"
  FILEPP_SOURCE_DIR="filepp-$FILEPP_VERSION"
  FILEPP_URL="http://www-users.york.ac.uk/~dm26/filepp/$FILEPP_TAR_GZ"

  if type wget &>/dev/null; then
    echo "Downloading \\"$FILEPP_URL\\" ..." >&2

    if ! wget "$FILEPP_URL" -O "$FILEPP_TAR_GZ" &>log; then
      cat log >&2
      echo "Error: Command failed: wget \\"$FILEPP_URL\\" -O \\"$FILEPP_TAR_GZ\\"" >&2
      exit 1
    fi
  elif type curl &>/dev/null; then
    echo "Downloading \\"$FILEPP_URL\\" ..." >&2

    if ! curl -L --fail "$FILEPP_URL" -o "$FILEPP_TAR_GZ" &>log; then
      cat log >&2
      echo "Error: Command failed: curl -L --fail \\"$FILEPP_URL\\" -o \\"$FILEPP_TAR_GZ\\"" >&2
      exit 1
    fi
  else
    echo "Error: No curl or wget found" >&2
    exit 1
  fi

  if ! type tar &>/dev/null; then
    echo "Error: No tar program found" >&2
    exit 1
  fi

  if ! type make &>/dev/null; then
    echo "Error: No make program found" >&2
    exit 1
  fi

  echo "Extracting archive ..." >&2

  if ! tar xf "$FILEPP_TAR_GZ" &>log; then
    cat log >&2
    echo "Error: Command failed: tar xf \\"$FILEPP_TAR_GZ\\"" >&2
    exit 1
  fi

  cd "$FILEPP_SOURCE_DIR"

  echo "Calling ./configure ..." >&2

  if ! ./configure --prefix="$FILEPP_DIR" &>log; then
    cat log >&2
    echo "Error: Command falied: ./configure --prefix=\\"$FILEPP_DIR\\"" >&2
    exit 1
  fi

  echo "Calling make ..." >&2

  if ! make &>log; then
    cat log >&2
    echo "Command failed: make" >&2
    exit 1
  fi

  echo "Calling make install ..." >&2

  if ! make install &>log; then
    cat log >&2
    echo "Command failed: make install" >&2
    exit 1
  fi

  cd "$OLDPWD"
} 

if [ $# -eq 0 ]; then
  echo "Error: Missing command" >&2
  echo >&2
  echo "Run '$0 help' for more information" >&2
  exit 1
elif [ $# -gt 1 ]; then
  echo "Error: Too many arguments" >&2
  echo >&2
  echo "Run '$0 help' for more information" >&2
  exit 1
elif [ "$1" = "apply" ]; then
  cmd_apply
elif [ "$1" = "build" ]; then
  cmd_build
elif [ "$1" = "clean" ]; then
  cmd_clean
elif [ "$1" = "diff" ]; then
  cmd_diff
elif [ "$1" = "install" ]; then
  cmd_install
elif [ "$1" = "show" ]; then
  cmd_show
elif [ "$1" = "help" ]; then
  cmd_help
else
  echo "Error: Unknown command: $1" >&2
  echo >&2
  echo "Run '$0 help' for more information" >&2
fi\
'''
    def __init__(self, package_name):
        self.package_name = package_name
        self.defines = OrderedDict()
        self.directories = set()
        self.files = []
        self.pre_build = None
        self.post_build = None
        self.post_install = None
        self.apply = None
        self.build_code = []

    def add_define(self, name, value, execute=False):
        if execute is False:
            self.defines[name] = shlex.quote(value)
        else:
            self.defines[name] = f'$({value.strip()})'

    def add_directory(self, directory):
        self.directories.add(directory)

    def add_file(self, file):
        self.files.append(file)

    def add_pre_build(self, code):
        self.pre_build = code

    def add_post_build(self, code):
        self.post_build = code

    def add_post_install(self, code):
        self.post_install = code

    def add_apply(self, code):
        self.apply = code

    def add_build_code(self, code):
        self.build_code.append(code)

    def get_define_vars_code(self):
        r = []

        for name, value in self.defines.items():
            r.append(f'{name}_default={value}')
            r.append(f'export {name}="${{{name}:-${name}_default}}"')
            r.append('')

        code = '\n'.join(r)
        return code.rstrip()

    def get_show_code(self):
        r =  [f'echo "Showing \\"$PACKAGE\\" ..." >&2']

        for name in self.defines.keys():
            r.append(f'printf "export %s=%q\\n" {name} "${name}"')

        code = '\n'.join(r)
        return 'cmd_show() {\n%s\n}' % indent(code, 2)

    def get_pre_build_code(self):
        r =  ['get_filepp']
        r += ['mkdir -p "$BUILD_DIR"']
        if self.pre_build:
            r += [self.pre_build]

        code = '\n'.join(r)
        return 'pre_build() {\n%s\n}' % indent(code, 2)

    def get_clean_code(self):
        r =  [f'echo "Cleaning up \\"$PACKAGE\\" ..." >&2']
        r += [f'rm -rf "$BUILD_DIR"']
        code = '\n'.join(r)
        return 'cmd_clean() {\n%s\n}' % indent(code, 2)

    def get_build_code(self):
        r =  [f'echo "Building \\"$PACKAGE\\" ..." >&2']
        r += [f'pre_build']
        for directory in sorted(self.directories):
            r += [f'mkdir -p "$BUILD_DIR/{directory}"']
        r += self.build_code
        r += [f'post_build']
        code = '\n'.join(r)
        return 'cmd_build() {\n%s\n}' % indent(code, 2)

    def get_post_build_code(self):
        r = []
        if self.post_build:
            r += [self.post_build]
        else:
            r += ['true']
        code = '\n'.join(r)
        return 'post_build() {\n%s\n}' % indent(code, 2)

    def get_post_install_code(self):
        r = []
        if self.post_install:
            r += [self.post_install]
        else:
            r += ['true']
        code = '\n'.join(r)
        return 'post_install() {\n%s\n}' % indent(code, 2)

    def get_apply_code(self):
        r =  [f'echo "Applying \\"$PACKAGE\\" ..." >&2']
        if self.apply:
            r += [self.apply]
        code = '\n'.join(r)
        return 'cmd_apply() {\n%s\n}' % indent(code, 2)

    def get_install_code(self):
        r =  [f'echo "Installing \\"$PACKAGE\\" ..." >&2']

        r += [f'if ! [ -d "$BUILD_DIR" ]; then']
        r += [f'  echo "Error: $BUILD_DIR: No such directory: Did you run \\"build\\" yet?" >&2']
        r += [f'  exit 1']
        r += [f'fi']

        for directory in self.directories:
            r += [f'mkdir -p "$DEST_DIR/{directory}"']

        for file in self.files:
            r += [f'cp -p "$BUILD_DIR/{file}" "$DEST_DIR/{file}"']

        r += ['post_install']

        code = '\n'.join(r)
        return 'cmd_install() {\n%s\n}' % indent(code, 2)

    def get_diff_code(self):
        r = [f'echo "Diffing \\"$PACKAGE\\" ..." >&2']

        r += [f'if ! [ -d "$BUILD_DIR" ]; then']
        r += [f'  echo "Error: $BUILD_DIR: No such directory: Did you run \\"build\\" yet?" >&2']
        r += [f'  exit 1']
        r += [f'fi']

        for file in self.files:
            r += [f'if [ -e "$DEST_DIR/{file}" ]; then']
            r += [f'  if ! $DIFF "$BUILD_DIR/{file}" "$DEST_DIR/{file}"; then']
            r += [f'    echo " ^--- {file}"']
            r += [f'  fi']
            r += [f'else']
            r += [f'  echo "No such file or directory: \'$DEST_DIR/{file}\'"']
            r += [f'fi']

        code = '\n'.join(r)
        return 'cmd_diff() {\n%s\n}' % indent(code, 2)

    def get_code(self):
        r = [
            PackageSh.SCRIPT_START.replace('%PACKAGE%', self.package_name),
            self.get_define_vars_code(),
            self.get_pre_build_code(),
            self.get_post_build_code(),
            self.get_build_code(),
            self.get_post_install_code(),
            self.get_install_code(),
            self.get_apply_code(),
            self.get_diff_code(),
            self.get_show_code(),
            self.get_clean_code(),
            PackageSh.SCRIPT_END
        ]

        code = '\n\n'.join(r)
        return code


def get_preprocessor(package):
    preprocessor = PreProcessor()
    #preprocessor.add_module_dir( os.path.join(SCRIPT_DIR, '.filepp_modules') ) TODO

    preprocessor.set_prefix(
        shlex.quote(package.get_preprocessor_prefix())
    )

    preprocessor.set_environment_prefix(
        shlex.quote(package.get_preprocessor_enviroment_prefix())
    )

    for module in package.get_preprocessor_modules():
        preprocessor.add_module(module)

    for directory in package.get_preprocessor_include_dirs():
        preprocessor.add_include_dir(directory)

    for name in package.get_defines().keys():
        preprocessor.add_define(name, f'"${name}"')

    return preprocessor

def make_package_sh(packagedir, opts):
    package  = Package('package.yaml')
    shfile   = PackageSh(packagedir)

    # =========================================================================
    # Add defines
    # =========================================================================

    for name, value in package.get_defines().items():
        value = value.strip()
        if value.startswith('SHELL:'):
            value = value.replace('SHELL:', '', count=1)
            shfile.add_define(name, value, execute=True)
        else:
            shfile.add_define(name, value)

    # =========================================================================
    # Add build hooks
    # =========================================================================

    shfile.add_pre_build(package.get_pre_build())
    shfile.add_post_build(package.get_post_build())
    shfile.add_post_install(package.get_post_install())
    shfile.add_apply(package.get_apply())

    # =========================================================================
    # Add template files
    # =========================================================================

    pp_files = package.get_pp_files_with_prefix()
    for file in pp_files:
        file.remove_preprocessor_extension()

        preprocessor = get_preprocessor(package)
        preprocessor.set_program('"$FILEPP"')
        preprocessor.set_input_file(file.input_file)
        preprocessor.set_output_file('"$BUILD_DIR/%s"' % file.output_file)
        preprocessor.add_module_dir('.filepp_modules')
        args = preprocessor.get_args()

        shfile.add_build_code(' '.join(args))
        shfile.add_directory(file.get_output_directory())
        shfile.add_file(file.output_file)

    # =========================================================================
    # Add raw files
    # =========================================================================

    raw_files = package.get_files_with_prefix()
    for file in raw_files:
        shfile.add_build_code(f'cp -p "{file.input_file}" "$BUILD_DIR/{file.output_file}"')
        shfile.add_directory(file.get_output_directory())
        shfile.add_file(file.output_file)

    # =========================================================================
    # Copy needed modules to .filepp_modules
    # =========================================================================

    for module in package.get_preprocessor_modules():
        module_path = os.path.join('..', '.filepp_modules', module)
        local_module = os.path.join('.filepp_modules', module)

        if os.path.exists(module_path):
            os.makedirs('.filepp_modules', exist_ok=True)
            shutil.copy(module_path, local_module)

    # =========================================================================
    # Get contents, write and make executable
    # =========================================================================

    code = shfile.get_code()

    with open('package.sh', 'w', encoding='UTF-8') as fh:
        fh.write(code)

    make_executable('package.sh')

argp = argparse.ArgumentParser()

argp.add_argument('PACKAGE_DIR', nargs='+')

opts = argp.parse_args()

for package_dir in opts.PACKAGE_DIR:
    try:
        with chdir(package_dir):
            make_package_sh(package_dir, None)
    except Exception as e:
        print(f'{package_dir}: {e}')
