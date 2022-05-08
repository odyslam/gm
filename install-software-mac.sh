install_software_mac() {
  if [[ $DEV_TOOLCHAIN == "true" ]]; then
    # Add radicle tap
    message "Adding brew taps.."
    message "Although 'git' is already installed by xcode cli utils, it will be downloaded again and managed by brew"
    brew tap radicle/cli https://seed.alt-clients.radicle.xyz/radicle-cli-homebrew.git
    apps=(
      tmux
      node
      ag
      bat
      exa
      jq
      git
      git-delta
      git-extras
      htop
      python3
      tree
      wget
      yarn
      libusb
      radicle/cli/core
      cloudflare-wrangler
      wifi-password
      balena-cli
      shellcheck
      hadolint
      asciinema
      gh
    )
  message "brew installing the following software: ${apps[*]}"
  for app in ${apps[*]}
    do
      brew install "${app}"
  done
  fi

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
      private-internet-access
      stremio
      google-drive
      1password
      visual-studio-code
      balenaetcher
      ledger-live
      gpg
    )
    message "brew installing the following GUI apps (casks): ${casks[*]}"
    for cask in ${casks[*]}
      do
        brew install --cask "${cask}"
    done
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
  fi

  appstore=(
    magnet
    streaks
  )
  message "The following apps will need to be installed manually via the app-store: ${appstore[*]}"
}

install_custom_zsh_plugins(){
  message "Installing custom ZSH plugins.."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/popstas/zsh-command-time.git ~/.oh-my-zsh/custom/plugins/command-time
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
}
