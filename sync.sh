#!/usr/bin/env bash

sync(){
  if [[ $1 == "local" ]]; then
    sync_local_to_repo
  elif [[ $1 == "repo" ]] || [[ $1 == "repository" ]]; then
    sync_repo_to_local
  else
      announce "Sync.sh: A helper file to sync dotfiles betweenn repo and system"
      message "local: Sync system to repo dotfiles"
      message "repo: Sync repo to system's dotfiles"
  fi
}

dotfiles=(
  .vimrc
  .zshrc
  .zshenv
  .tmux.conf.local
  .gitconfig
  .alacritty.yml
  .gitignore
  .dircolors
)

sync_repo_to_local(){
  announce "Copying system's dotfiles to this repository.."
  message "It will copy the following dotfiles: ${dotfiles[*]}"
  for dotfile in ${dotfiles[*]}
    do
      cp -rf "${HOME}/${dotfile}" "${dotfile}"
  done
  rm -rf .vim && rm -rf .config/nvim
  cp -R ~/.vim/ .vim/ 2>/dev/null
  cp -R ~/.config/nvim .config/nvim/

  message "Updating brew-apps.txt via brew leaves.."
  brew leaves > brew-apps.txt
}
sync_local_to_repo(){
  announce "Copying the dotfiles from this repository over to the system.."
  message "It will copy the following dotfiles: ${dotfiles[*]}"
  for dotfile in ${dotfiles[*]}
    do
      cp -rf "${dotfile}" "${HOME}/${dotfile}"
  done
  rm -rf ~/.vim && rm -rf ~/.config/nvim
  cp -R .vim ~/.vim 2>/dev/null
  cp -r .config/nvim/ ~/.config/nvim

  message "Installing nvim plugins.."
  warning "The error messages are normal, as the plugins haven't been installed yet"
  nvim --headless +PlugInstall +qa
  message "Nvim plugins have been installed"
}
