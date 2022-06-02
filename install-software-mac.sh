install_software_mac() {
  if [[ $DEV_TOOLCHAIN == "true" ]]; then
    # Add radicle tap
    message "Adding brew taps.."
    message "Although 'git' is already installed by xcode cli utils, it will be downloaded again and managed by brew"
    apps="($(cat brew-apps.txt))"
  message "Installing the following binaries, via brew: ${apps[*]}.."
  for app in ${apps[*]}
    do
      brew install "${app}"
  done
  fi

  # This is required to use gpg signed commits and use git plugins in vim
  # https://github.com/tpope/vim-fugitive/issues/1645
  # https://byparker.com/blog/2021/gpg-pinentry-mac-git/
  message "Adding pinentry to 'gpg-agent.conf'.."
  echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
  gpgconf --kill gpg-agent

  if [[ $GUI == "true" ]]; then
    casks=(
      alacritty
      flux
      raycast
      docker
      slack
      spotify
      discord
      cron
      signal
      telegram
      whatsapp
      brave-browser
      todoist
      rotki
      stremio
      google-drive
      1password
      visual-studio-code
      balenaetcher
      ledger-live
      clickup
      viber
      private-internet-access
      postman

    )
    # casks="($(cat brew-casks.txt))"
    message "Installing the following GUI apps, via brew (casks): ${casks[*]}.."
    for cask in ${casks[*]}
      do
        brew install --cask "${cask}"
    done


    # Install Urbit
    message "Installing Urbit v1.9.."
    curl "https://github.com/urbit/urbit/releases/download/urbit-v1.9/darwin.tgz"
    curl tar -xvzf darwin.tgz
    cd "urbit-v1.8-x86_64-darwin"
    mkdir ~/.urbit && mkdir ~/.urbit/bin && mkdir ~/.urbit/piers
    sudo mv urbit ~/.urbit/bin/urbit
    mv urbit-worker ~/.urbit/bin/urbit-worker
    mv urbit-king ~/.urbit/bin/urbit-king
    cd .. && rm -rf "urbit-v1.8-x86_64-darwin"
    message "Urbit Installed at ~/.urbit/"
    message "Piers can be placed at ~/.urbit/piers"
    message "Pier directory is available under the 'URBIT_PIERS' env. variable"
    warning "You might need Rosetta to run Urbit"

  fi
  if [[ $DEV_TOOLCHAIN == "true" ]]; then
    message "Installing coreutils.."
    export DOTFILES_BREW_PREFIX_COREUTILS=`brew --prefix coreutils`
    set-config "DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_CACHE"
    message "Installing xcode utils.."
    xcode-select --install
    message "Installing Oh my tmux.."
    # Oh my tmux
     cd
     git clone https://github.com/gpakosz/.tmux.git
     ln -s -f .tmux/.tmux.conf
     cp .tmux/.tmux.conf.local .
    # Oh my zsh
    message "Installing Oh my zsh.."
    # Make sure that oh-my-zsh installs files for the current user, not root
    # https://github.com/ohmyzsh/ohmyzsh/issues/8477
    export ZSH=$HOME/.oh-my-zsh
    # Make sure it's a fresh in
    rm -rf ~/.oh-my-zsh
    # https://github.com/ohmyzsh/ohmyzsh#unattended-install
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # Finally, install custom ZSH plugins
    install_custom_zsh_plugins
    install_custom_fonts
  fi

  appstore=(
    magnet
    streaks
    spark
  )

  warning "The following apps will need to be installed manually via the app-store: ${appstore[*]}"
}

install_custom_zsh_plugins(){
  message "Installing custom ZSH plugins.."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/popstas/zsh-command-time.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/command-time
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
}

install_custom_fonts(){
  message "Installing Powerline Fonts.."
  git clone https://github.com/powerline/fonts.git --depth=1
  # install
  cd fonts
  ./install.sh
  # clean-up a bit
  cd ..
  rm -rf fonts
}
