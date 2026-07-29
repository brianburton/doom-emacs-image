# Doom Emacs Image

A simple doom emacs docker image plus configuration for simple
java development and org mode.  Also includes a small launcher
script that creates a single use container with volumes mounted
to allow caches and state to me maintained between runs.

## Installation

CD into `docker` and run the `build.sh` script to create an image
named `doom-emacs`.  Copy the `de` script to somewhere in your PATH.
Create a directory named `doom-emacs` in your home directory.

Decide where you want to allow editing.  The script will only
allow you to specify a file or directory under your home directory
that contains a file named `.edit_accept` in the directory or one
of its ancestors.  If a file named `.edit_reject` is found the
script will refuse to run the container.   NOTE: This check is
only done between the file/directory and your home directory.
If a directory `~/a/b` contains `.edit_acept` and the directory
`~/a/b/c` contains `.edit_reject` the script will still let
you edit `~/a/b` even though doing so will mount `c` in the 
container.  The access checks are just rudimentary and intended
to wall off whole trees rather than provide fine grained access 
control.

The script will create a directory named ~/doom-emacs/volumes` and
mount directories that emacs uses to cache files between runs.
Doing so allows emacs to start more quickly and retain information
like lsp state across runs.

## de script

The script requires a single argument which is a file or directory.
After applying the access check the script searches for a project
root related to the argument.  It will run the container with that
project root mounted.  If you use the `-j` option it will also mount
a `m2` directory so that java artifacts can be cached between runs.
If you have a `~/org` directory it will also mount that so that
it can be used by org mode.

The `-n` argument allows programs inside the container to access
the network.  The `j` argument allows programs to access the network,
mounts the `m2` directory, and increases the amount of RAM the
container can use.

## Miscelaneous

I find this useful but make no promises as to its usefulness for anyone else!
It is intended to be safe to use but I make no guarantees in that regard.
Feel free to use, adapt, and share this as you see fit.
