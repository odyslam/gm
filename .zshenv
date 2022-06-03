PYTHON_PATH="$(python3 -m site --user-base)/bin"
export PATH=/opt/homebrew/bin:/usr/bin:~/bin:~/.local/bin:~/.yarn/bin:~/.cargo/bin:~/.radicle/bin:/usr/local/sbin:~/.foundry/bin:${PYTHON_PATH}
export EDITOR=nvim
export VISUAL=nvim
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
source ~/.zsh_secrets
source "$HOME/.cargo/env"

if [[ $(which git) != "/opt/homebrew/bin/git" ]]; then
  warning "The system is not configured to use brew's Git. Current Git path: $(which git)"
fi
. "$HOME/.cargo/env"
