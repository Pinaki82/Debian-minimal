#!/bin/bash

# Encrypt Folders using "AES Crypt" (https://www.aescrypt.com/).

# https://alternativeto.net/software/folder-lock/?license=opensource
# https://www.aescrypt.com/

# "AES Crypt" requires Java Runtime Environment.
# sudo apt install default-jre

# Use VeraCrypt to encrypt large volumes.

EncryptFolder() {
    tar -rvf $archivename.tar $foldername/ && \

    aescrypt -e $archivename.tar \

}

DecryptFolder() {
    aescrypt -d $archivename.tar.aes && \

    tar -xvf $archivename.tar \

}

echo "========================================="
echo "Usage: ./aesencrypt-ed.sh folder/ archive"
echo "========================================="
echo "Where 'folder' is the folder to encrypt/decrypt, and 'archive' is the encrypted archive."
echo "Folder/archive names must not contain spaces or special characters."

echo "Type the folder name: (Press TAB to autocomplete.)"
echo "Type the archive name: (Press TAB to autocomplete if the archive exists.)"
echo "Type out the archive name. Do not write the dots or anything after the dots."
echo "That means you should type arch instead of typing arch.tar.aes"
echo ""
echo "Press TAB to autocomplete."

echo "folder name (input): $1"
foldername=$1
echo folder-name: $foldername

echo "archive name (input): $2"
archivename=$2
echo archive-name: $archivename

echo "Encrypt? (1) or Decrypt (2)?"
echo "   (Press CTRL+c to kill the script.)"
echo "   (Or, type a number other than 1 or 2.)"
read choice
echo "Your input was $choice"

if [[ "${choice}" == '1' ]]; then
    echo "You want to encrypt $foldername"
    echo "Your encrypted archive will be $archivename.tar.aes"

    EncryptFolder

elif [[ "${choice}" == '2' ]]; then
    echo "You want to decrypt $archivename"

    DecryptFolder

else
  echo "Invalid input!"
  exit

fi
