system_setup_mac(){
  message "Set caps lock to control ⌃ and vice-versa"
  message "Turn On 'Do Not Disturb"
  message "Increase touchpad sensitivity to maximum"
  # Moving dock to the right
  defaults write com.apple.dock orientation right
  #restart Dock
  killall Dock
}

system_setup_linux(){
  warning "System setup for Linux is still TBD"
}
