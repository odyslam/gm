PYTHON_PATH="$(python3 -m site --user-base)/bin"
export PATH=/opt/homebrew/bin:/usr/bin:~/bin:~/.local/bin:~/.yarn/bin:~/.cargo/bin:~/.radicle/bin:/usr/local/sbin:~/.foundry/bin:${PYTHON_PATH}:~/.urbit/bin
export EDITOR=nvim
export VISUAL=nvim
export NVM_DIR="$HOME/.nvm"
export URBIT_PIERS="$HOME/.urbit/piers"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
source ~/.zsh_secrets
