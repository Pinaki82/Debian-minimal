#!/bin/bash

# Completely automated update setup

# References:
# https://unix.stackexchange.com/questions/87776/shell-script-syntax-error-near-unexpected-token-else
# https://linuxhandbook.com/if-else-bash/
# https://www.fosslinux.com/42541/bash-script-examples.htm
# https://linuxhandbook.com/bash-functions/

# Function declarations
UpdateNUpgrade() { # Update & Upgrade
  echo "Next: sudo apt update"
  sleep 2
  yes | sudo apt update
  echo "Next: sudo apt list --upgradable"
  sleep 2
  yes | sudo apt list --upgradable
  echo "Next: sudo apt upgrade"
  sleep 2
  yes | sudo apt upgrade
  echo "Next: sudo apt update"
  sleep 2
  yes | sudo apt update
  echo "Next: sudo apt install -f"
  sleep 2
  yes | sudo apt install -f
}

clean_residual(){ # clean residual packages
  echo "Next: sudo apt autoremove"
  sleep 2
  yes | sudo apt autoremove
  echo "Next: sudo apt autoclean"
  sleep 2
  yes | sudo apt autoclean
}

# Body of code
echo "Please add an alias to .bashrc to simplify the update task. Read the instructions written under comments inside the shell script."
echo "Type 0 [zero in number] to cancel"
echo "Update?(no=0)"
read choice
echo "Your input was $choice"
if [ "${choice}" != '0' ]; then
  echo "Wait till the update process is complete..."

  sleep 2 # https://stackoverflow.com/questions/21620406/how-do-i-pause-my-shell-script-for-a-second-before-continuing

  # Update & Upgrade
  UpdateNUpgrade
  UpdateNUpgrade

  # clean
  clean_residual
  clean_residual

else
  echo "Update cancelled by the user"

fi

# ALIAS
# Add an alias to .bashrc:
# https://linuxize.com/post/how-to-create-bash-aliases/
# Open ~/.bashrc with any of your favourite text editor and paste the
# following lines after the last line:

# # # # # # # # # # # # # # # # # # # # # # # # # # #
# https://linuxize.com/post/how-to-create-bash-aliases/
# Aliases
# alias alias_name="command_to_run"

# Update #NOTE: uncomment the line below in .bashrc
# alias upd="sh ~/shell/000update-n-clean-automated.sh"
# Print my public IP #NOTE: uncomment the line below in .bashrc
# alias myip='curl ipinfo.io/ip'

# save and close the file. Make the aliases available
# in your current session by typing:
# source ~/.bashrc
# in the terminal

# From now on, you will be able to update the system by typing
# 'upd' (of course, without the quotes) in the terminal
# # # # # # # # # # # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # # # # # # # # # # #
# Fish Shell Aliases
# Config File: ~/.config/fish/config.fish
# alias alias_name="command_to_run"

# Update #NOTE: uncomment the line below in  ~/.config/fish/config.fish

# alias upd="sh ~/shell/000update-n-clean-automated.sh"
# Other examples:
# alias trim="sh ~/shell/ssd_trim.sh"
# Print my public IP #NOTE: uncomment the line below in .bashrc
# alias myip='curl ipinfo.io/ip'

# save and close the file. Make the aliases available
# in your current session by typing:
# source ~/.config/fish/config.fish
# in the terminal

# Done!!
# # # # # # # # # # # # # # # # # # # # # # # # # # #

