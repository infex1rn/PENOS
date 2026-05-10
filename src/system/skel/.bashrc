# PENOS Bash Profile
export EDITOR=nano
export VISUAL=nano
export HISTSIZE=10000
export HISTFILESIZE=20000

# Load starship if installed
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# Load zoxide if installed
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

# Welcome the user
pen-fetch
