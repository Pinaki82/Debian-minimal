#!/bin/bash

# https://superuser.com/questions/307853/permission-denied-when-accessing-virtualbox-shared-folder-when-member-of-the-vbo

sudo usermod -aG vboxsf $(whoami) \

