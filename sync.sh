#!/usr/bin/env bash

sync(){
  echo $1
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

sync_repo_to_local(){
  announce "Copying system's dotfiles to this repository.."
  cp ~/.vimrc .vimrc
  cp ~/.zshrc .zshrc
  cp ~/.zshenv .zshenv
  cp ~/.tmux.conf.local .tmux.conf.local
  cp ~/.gitconfig .gitconfig
  cp ~/.gitignore .gitignore
  cp ~/.dircolors .dircolors
  cp -R ~/.vim/ .vim/ 2>/dev/null
  cp -R ~/.config/nvim .config/nvim/
  cp -R ~/.config/coc .config/coc/
}
sync_local_to_repo(){
  announce "Copying the dotfiles from this repository over to the system.."
  cp .vimrc ~/.vimrc
  cp .zshrc ~/.zshrc
  cp .zshenv ~/.zshenv
  cp .tmux.conf.local ~/tmux.conf.local
  cp .gitconfig ~/.gitconfig
  cp .gitignore ~/.gitignore
  cp .dircolors ~/.dircolors
  cp -R .vim ~/.vim 2>/dev/null
  cp -r .config/nvim/ ~/.config/nvim
  cp -r .config/coc/ ~/.config/coc
}
