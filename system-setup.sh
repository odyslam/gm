system_setup_mac(){
  announce "Don't forge to manually setup the following:"
  message "Set caps lock to control ⌃ and vice-versa"
  message "Turn On 'Do Not Disturb"
  message "Increase touchpad sensitivity to maximum"
  message "Enable 'click on top' for the trackpad"
  message "Moving dock to the right.."
  defaults write com.apple.dock orientation right
  killall Dock
}

system_setup_linux(){
  warning "System setup for Linux is still TBD"
}
