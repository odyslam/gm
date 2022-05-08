#!/usr/bin/env bash

# Source functions

source ./install-software-mac.sh
source ./install-software-linux.sh
source ./install-software-eth.sh
source ./install-software-common.sh
source ./sync.sh
source ./terminal-helpers.sh
source ./system-setup.sh

# Intro

welcome() {

  cat << 'EOF'
   _______________________________
  <  Welcome to Odysseas' setup   >
   -------------------------------
      \
       \
                .,-:;//;:=,
            . :H@@@MM@M#H/.,+%;,
         ,/X+ +M@@M@MM%=,-%HMMM@X/,
       -+@MM; $M@@MH+-,;XMMMM@MMMM@+-
      ;@M@@M- XM@X;. -+XXXXXHHH@M@M#@/.
    ,%MM@@MH ,@%=            .---=-=:=,.
    =@#@@@MX .,      WE      -%HX$$%%%+;
   =-./@M@M$         DO       .;@MMMM@MM:
   X@/ -$MM/        WHAT        .+MM@@@M$
  ,@M@H: :@:         WE         . =X#@@@@-
  ,@@@MMX, .        MUST        /H- ;@M@M=
  .H@@@@M@+,      BECAUSE       %MM+..%#$.
   /MMMM@MMH/.       WE         XM@MH; =;
    /%+%$XHH@$=     CAN      , .H@@@@MX,
     .=--------.           -%H.,@@@@@MX,
     .%MM@@@HHHXX$$$%+- .:$MMX =M@@MM%.
       =XMMM@MM@MM#H;,-+HMM@M+ /MMMX=
         =%@M@M#@$-.=$@MM@@@M; %M%=
           ,:+$+-,/H#MMMMMMM@= =,
                 =++%%%%+/:-.

EOF

}

print_usage(){
  echo
  cat << "EOF"
                          .         .
     ,o888888o.          ,8.       ,8.                    8 8888      88    d888888o.           .8.           ,o888888o.    8 8888888888
    8888     `88.       ,888.     ,888.                   8 8888      88  .`8888:' `88.        .888.         8888     `88.  8 8888
 ,8 8888       `8.     .`8888.   .`8888.                  8 8888      88  8.`8888.   Y8       :88888.     ,8 8888       `8. 8 8888
 88 8888              ,8.`8888. ,8.`8888.                 8 8888      88  `8.`8888.          . `88888.    88 8888           8 8888
 88 8888             ,8'8.`8888,8^8.`8888.                8 8888      88   `8.`8888.        .8. `88888.   88 8888           8 888888888888
 88 8888            ,8' `8.`8888' `8.`8888.               8 8888      88    `8.`8888.      .8`8. `88888.  88 8888           8 8888
 88 8888   8888888 ,8'   `8.`88'   `8.`8888.              8 8888      88     `8.`8888.    .8' `8. `88888. 88 8888   8888888 8 8888
 `8 8888       .8',8'     `8.`'     `8.`8888.             ` 8888     ,8P 8b   `8.`8888.  .8'   `8. `88888.`8 8888       .8' 8 8888
    8888     ,88',8'       `8        `8.`8888.              8888   ,d8P  `8b.  ;8.`8888 .888888888. `88888.  8888     ,88'  8 8888
     `8888888P' ,8'         `         `8.`8888.              `Y88888P'    `Y8888P ,88P'.8'       `8. `88888.  `8888888P'    8 888888888888
EOF
  echo
  echo
  message "${TPUT_BOLD}-g${TPUT_RESET}: Install GUI applications (e.g slack)"
  message "${TPUT_BOLD}-d${TPUT_RESET}: Install dotfiles"
  message "${TPUT_BOLD}-t${TPUT_RESET}: Install development toolchain"
  message "${TPUT_BOLD}-s${TPUT_RESET}: Output instructions to setup the system (configuration, peripherals, etc.)"
  message "${TPUT_BOLD}-a${TPUT_RESET}: Install all the above"
  message "${TPUT_BOLD}-u${TPUT_RESET}: Update the dotfiles in this repository to the system's"
}

# Installation types

GUI="false"
DOTFILES="false"
DEV_TOOLCHAIN="false"

while getopts 'gdtsau' OPTION; do
  case "${OPTION}" in
    a) GUI="true" && DEV_TOOLCHAIN="true" && DOTFILES="true" SYSTEM_SETUP='true';;
    d) DOTFILES="true";;
    g) GUI="true";;
    t) DEV_TOOLCHAIN="true";;
    u) UPDATE="true";;
    s) SYSTEM_SETUP="true";;
    *) echo && warning "flag is not recognised. Please read usage:" && print_usage
      exit 1;;
  esac
done

# Check if no options were passed
if [ $OPTIND -eq 1 ]; then
  echo
  warning "No options were passed"
  message "Use '-h' to print all available options"
  exit 1
fi

welcome

if [[ "${UPDATE}" == "true" ]]; then
  sync repo
  exit 1
fi

message "The following software suites will be installed on the system:"
message "GUI apps:              ${TPUT_BOLD}$GUI${TPUT_RESET}"
message "Dotfiles:              ${TPUT_BOLD}$DOTFILES${TPUT_RESET}"
message "Development Toolchain: ${TPUT_BOLD}$DEV_TOOLCHAIN${TPUT_RESET}"
message "System Setup:          ${TPUT_BOLD}$SYSTEM_SETUP${TPUT_RESET}"
warning "'sudo' may be required during the installation process. A prompt will ask your for your password"

# Read input and advance only if user agrees
read -p "Ready to Install? [y/n] " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
# Print an empty line
echo
echo
# Install apps and toolchain based on the OS type and then  install the common
# If macOS, it uses brew as the package manager
# If Linux, it depends:
# - Debian/Ubuntu:
#   - They are known for having a very long release process and a lot of the packages
#     on the main package repository are stale. I will propably use the package manager
#     with the repositories that are managed by the project/software themselves.
if [[ $(uname) == 'Darwin'* ]]; then
# move to right
defaults write com.apple.dock orientation right
#restart Dock
killall Dock
  message "MacOS detected"
  if ! [ -x "$(which brew)" ]; then
    message "Adding brew to path.."
    export PATH=$PATH:/opt/homebrew/bin
    message "Installing brew.."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
  message "brew already installed, skipping.."
  install_software_mac
  if [[ "${SYSTEM_SETUP}" == "true" ]]; then
    system_setup_mac
  fi
elif [[ $(uname) == 'Linux' ]]; then
  message "Linux detected"
  install_software_linux
  if [[ "${SYSTEM_SETUP}" == "true" ]]; then
    system_setup_linux
  fi
fi

if [[ $DEV_TOOLCHAIN == "true" ]]; then
  install_software_eth
  install_software_common
fi

if [[ $DOTFILES == "true" ]]; then
  message "Installing dotfiles"
  message "Please visit ~/.zsh/zsh_secrets and populate your API keys"
  echo -e "export BALENA_TOKEN=\nexport ETHERSCAN_API_KEY\nexport ETH_RPC_URL=" > ~/.zsh/zsh_secrets
  sync local
fi

