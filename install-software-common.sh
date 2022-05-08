install_software_common(){
  message "Installing Node via NVM.."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

  message "Installing Rust.. via Rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

  message "Installing Typescript (globally).."
  npm install -g typescript
  npm install -g ts-node

  message "Installing tranmissions11/headers.."
  git clone https://github.com/transmissions11/headers
  cd headers && cargo build --release
  cp target/release/headers ~/.cargo/bin/headers
  cd .. && rm -rf headers

  message "Installing Powerfiline Fonts.."
  git clone https://github.com/powerline/fonts.git --depth=1
  # install
  cd fonts
  ./install.sh
  # clean-up a bit
  cd ..
  rm -rf fonts
}
