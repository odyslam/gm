#!/usr/bin/env bash

# Source functions

source ./install-software-mac.sh
source ./install-software-linux.sh
source ./install-software-eth.sh
source ./install-software-common.sh
source ./sync.sh
source ./terminal_helpers.sh

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
  announce "gm.sh Usage"
  message "${TPUT_BOLD}-g${TPUT_RESET}: Install GUI applications (e.g slack)"
  message "${TPUT_BOLD}-d${TPUT_RESET}: Install dotfiles"
  message "${TPUT_BOLD}-t${TPUT_RESET}: Install development toolchain"
  message "${TPUT_BOLD}-a${TPUT_RESET}: Install all the above"
  message "${TPUT_BOLD}-s${TPUT_RESET}: Sync the dotfiles in this repository to the system's"
}

# Installation types

GUI="false"
DOTFILES="false"
DEV_TOOLCHAIN="false"

while getopts 'adgths' OPTION; do
  case "${OPTION}" in
    a) GUI="true" && DEV_TOOLCHAIN="true" && DOTFILES="true";;
    d) DOTFILES="true";;
    g) GUI="true";;
    t) DEV_TOOLCHAIN="true";;
    s) SYNC="true";;
    *) echo && warning "flag is not recognised. Please read usage:" && print_usage
      exit 1;;
  esac
done
if [ $OPTIND -eq 1 ]; then
  echo
  warning "No options were passed. Please run the script again and pass an option"
  message "Pass -h to print all available options"
  exit 1
fi
welcome
if [[ "${SYNC}" == "true" ]]; then
  sync repo
  exit 1
fi

message "The following software suites will be installed on the system:"
message "GUI apps:              ${TPUT_BOLD}$GUI${TPUT_RESET}"
message "Dotfiles:              ${TPUT_BOLD}$DOTFILES${TPUT_RESET}"
message "Development Toolchain: ${TPUT_BOLD}$DEV_TOOLCHAIN${TPUT_RESET}"

# Read input and advance only if user agrees
read -p "Ready to Install? [y/n] " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

if [[ $(uname) == 'Darwin'* ]]; then
  message "MacOS detected"
  if ! [ -x "$(which brew)" ]; then
    message "Installing brew"
    /usr/bin/ruby -e \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  install_software_mac
elif [[ $(uname) == 'Linux' ]]; then
  message "Linux detected"
  install_software_linux
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
