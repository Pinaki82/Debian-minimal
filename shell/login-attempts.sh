#!/bin/bash

# LOGIN ATTEMPTS
# https://linuxhint.com/check-user-login-history-linux/

printf "command: last $(whoami) -5 \n"
last $(whoami) -5
printf "\ncommand: lastlog | grep $(whoami) \n"
lastlog | grep $(whoami)

# ============ Shows all past logins: ==================
# printf "\ncommand: last | grep $(whoami) \n"
# last | grep $(whoami)

printf "\nInforms about the failed login attempts...\n"
printf "\nThe following commands need root access.\nDo you want to continue? (no=0)\n"
read choice
if [ "${choice}" = '0' ]; then
  printf "\nOK! The script will exit.\n"
  sleep 1
  exit 1
else
  printf "\nExecuting the command: sudo last -f /var/log/btmp \n"
  sudo last -f /var/log/btmp
  printf "\ncommand: sudo lastb \n"
  sudo lastb
fi
