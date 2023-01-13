TMUX_VERSION := $(shell if which tmux >/dev/null 2>/dev/null; then \
						tmux -V | sed 's/tmux //'; \
					else \
						echo 0.0; \
					fi )

GEMPATH := $(shell if which gem >/dev/null 2>/dev/null; then \
			 				gem env gempath; \
				fi )

PRESERVE_ROOT := $(shell if cp --help 2>&1 | grep -q -- --preserve-root; then \
					 		echo --preserve-root; \
						fi)

LS_COLOR := $(shell if ls --help 2>&1 | grep -q -- --color; then \
			  		echo --color=auto; \
				else \
					echo -G; \
				fi)

HAVE_NVIM := $(shell which nvim >/dev/null 2>/dev/null && echo 1 || echo 0)

HAVE_MAN_PROMPT := $(shell if man --help 2>&1 | grep -q -- --prompt; then \
		  					echo 1; \
						else \
							echo 0; \
						fi)
