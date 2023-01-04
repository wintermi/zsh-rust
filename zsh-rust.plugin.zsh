#!/usr/bin/env zsh
# shellcheck disable=SC1090

# Exit if the .cargo/bin directory does not exist
if [ ! -d "$HOME/.cargo/bin" ]; then
    echo 'ERROR: $HOME/.cargo/bin directory not found'
    return
fi

# ZSH equivalent to the "rustup shell startup"
typeset -TUx PATH path
path=("$HOME/.cargo/bin" $path)

# Exit if the 'rustup', 'rustc' or 'cargo' command can not be found
if ! (( $+commands[rustup] && $+commands[rustc] && $+commands[cargo] )); then
    echo "ERROR: 'rustup', 'rustc' or 'cargo' command not found"
    return
fi

# Completions directory for `rustup` and `cargo` commands
local COMPLETIONS_DIR="${0:A:h}/completions"

# Only regenerate completions if older than 24 hours, or does not exist
if [[ ! -f "$COMPLETIONS_DIR/_rustup"  ||  ! $(find "$COMPLETIONS_DIR/_rustup" -newermt "24 hours ago" -print) ]]; then
    rustup completions zsh rustup >| "$COMPLETIONS_DIR/_rustup"
    cp -f "$(rustc --print sysroot)/share/zsh/site-functions/_cargo" "$COMPLETIONS_DIR/_cargo"
fi

# Add completions to the FPATH
typeset -TUx FPATH fpath
fpath=("$COMPLETIONS_DIR" $fpath)
