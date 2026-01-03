# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Re-enable command hashing for nvm (Omarchy disables it for mise)
set -h

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
. "$HOME/.cargo/env"

. "$HOME/.local/share/../bin/env"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export API_KEY="AIzaSyCHXOeScV6ixnro-XcelGhhBd5E1A4fuLE"

export PATH="$PATH:/home/rooutt/.config/.foundry/bin"

# Zoxide - smarter cd command (use 'z' instead of 'cd')
eval "$(zoxide init bash)"
