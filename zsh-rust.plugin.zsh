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

# Exit if the 'rustup' or 'cargo' commands can not be found
if ! (( $+commands[rustup] && $+commands[cargo] )); then
    echo "ERROR: 'rustup' or 'cargo' commands not found"
    return
fi

# Completions directory for `rustup` and `cargo` commands
ZSH_RUST_DIR="${0:A:h}/completions"

# Only regenerate completions if older than 24 hours, or does not exist
if [[ ! -f "$ZSH_RUST_DIR/_rustup"  ||  $(find "$ZSH_RUST_DIR/_rustup" -mtime +24h -print) ]]; then
    rustup completions zsh rustup >| "$ZSH_RUST_DIR/_rustup"
    cp -f "$(rustc --print sysroot)/share/zsh/site-functions/_cargo" "$ZSH_RUST_DIR/_cargo"
fi

# Add completions to the FPATH
fpath=("$ZSH_RUST_DIR" $fpath)
