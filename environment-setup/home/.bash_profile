# standard PATH
export PATH=$PATH:/usr/local/sbin

# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

# colours
export CLICOLOR=1
export TERM=xterm-256color
export LSCOLORS=ExFxCxDxBxegedabagacad

# vim as default editor
export EDITOR='vim'

# prompt
PS1='[\u@\h:\w]\$ '

# ulimit
ulimit -n 4096

# build
export CC=gcc-4.2
export CXX=g++-4.2
export FFLAGS=-ff2c

# aliases, path extensions go in here
source ~/.profile

# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

