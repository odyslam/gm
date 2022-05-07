install_software_common(){
  message "Installing Node via NVM.."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

  message "Installing Rust.. via Rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

  message "Installing Typescript (globally).."
  npm install -g typescript
  npm install -g ts-node
}
