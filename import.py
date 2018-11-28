#!/usr/bin/python3

''' Import existing dotfiles into dotfiles folder '''

import sys, os, re
import argparse

argp = argparse.ArgumentParser(description=__doc__)
argp.add_argument('--dotfile-dir',
    help='Path to import the dotfiles'
)
#argp.add_argument('--import-base')
argp.add_argument('file',
    help='...',
    nargs='+'
)

def get_package_name(filename):
    re.sub('\.?(conf|rc)', '', filename).lstrip('.')

def split_path(filename):
    splitted = filename.split(os.path.sep)

    try:
        if splitted[0] == '':
            del splitted[0]
    except:
        pass

    return splitted

def import_rc(
    f,
    base_home,
    dotfiles_dir
):
    f2 = os.path.relpath(f, base_home)
    parts = split_path(f2)

    pkg_name = ''
    pkg_files = {}
    makefile_lines = []

    # ~/.inputrc
    # ~/.config/kwin.rc
    if os.path.isfile(f):
        if len(parts) == 1:
            if not parts[0].startswith('.'):
                raise Exception("File does not start with a dot: %s" % f)
            else
                pkg_name = get_package_name(parts[0])
                pkg_files[f] = parts[0][1:]
        elif len(parts) == 2:
            if parts[0] != '.config':
                raise Exception("Single configuration files outside '.config' not supported")
            elif parts[1].startswith('.'):
                raise Exception("Configuration files with leading dots inside '.config' not supported")
            else:
                pkg_name = get_package_name(parts[1])
                pkg_files[f] = parts[1]
                makefile_lines.append('PREFIX_DIR = .config')
            pass
        else:
            raise Exception("Not supported...")
    elif os.path.isdir(f):
        if len(parts) == 1:
            if not parts[0].startswith('.'):
                raise Exception("Directory does not start with a dot: %s" % f)
            else:
                pkg_name = get_package_name(parts[0])
                pkg_files ... todo
        elif len(parts) == 2:
            pass
        else:
            raise Exception("")
    else:
        raise Exception("Not a file or a dir: %s" % f)

options = argp.parse_args()

for f in options.file:
    import_rc(f,
        base_home=os.path.expanduser('~'),
        dotfiles_dir=os.path.dirname(os.path.abspath(sys.argv[0]))
    )
