#!/bin/sh
# shellcheck disable=SC1090

# Exit if the .cargo/bin directory does not exist
if [ ! -d "$HOME/.cargo/bin" ]; then
    echo 'ERROR: $HOME/.cargo/bin directory not found'
    return
fi

# ZSH equivalent to the "rustup shell startup"
typeset -TUx PATH path
path=("$HOME/.cargo/bin" $path)

