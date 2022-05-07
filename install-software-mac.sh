install_software_mac() {
  if [[ $DEV_TOOLCHAIN == "true" ]]; then
    # Add radicle tap
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
    )
  message "Brew will install the following cli apps: $apps"
  for app in ${apps[*]}
    do
      brew install "${app}"
  done
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
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
      cask
      private-internet-access
      stremio
      google-drive
      1password
      visual-studio-code
      balenaetcher
      ledger-live
    )
    message "Brew will install the following GUI apps (casks): ${casks}"
    for app in ${casks[*]}
      do
        brew install --cask "${cask}"
    done
  fi
  appstore=(
    magnet
  )
  message "The following apps will need to be installed via the app-store: ${appstore}"
}
