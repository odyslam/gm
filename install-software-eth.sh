install_software_eth(){
  message "Installing Foundry.."
  curl -L https://foundry.paradigm.xyz | bash
  foundryup
  message "Installing Slither.."
  # Install Slither static analyzer
  pip3 install slither-analyzer
  ping6::
  message "Installing SVM-rs.."
  # Install Solidity Version Manager
  cargo install svm-rs
}
