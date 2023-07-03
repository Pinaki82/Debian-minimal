set PATH $PATH /usr/local/bin
# $HOME/.local/bin
export PATH="$HOME/.local/bin/:$PATH"
export PATH

# Bitwarden Password Manager to the search path
# Bitwarden Password Manager to the search path
# mkdir $HOME/.bw
# Put 'bw' in that folder
# chmod +x bw
# source ~/.config/fish/config.fish
set PATH $PATH "$HOME/.bw/:$PATH"
export PATH

 
function ll
    ls -lh $argv
end

# Update using 'apt'.
alias upda="sh ~/shell/000update-n-clean-automated.sh"
# Update using 'nala'.
alias updn="sh ~/shell/000update-n-clean-automated-nala.sh"
# TRIM SSDs.
alias trim="sh ~/shell/ssd_trim.sh"

# req. by 'autojump'
# https://codeyarns.com/tech/2014-02-27-how-to-install-autojump-for-fish.html#gsc.tab=0

begin
    set --local AUTOJUMP_PATH $HOME/.autojump/share/autojump/autojump.fish
    if test -e $AUTOJUMP_PATH
        source $AUTOJUMP_PATH
    end
end

# req. by 'thef__k'
# Dependency: omf (OH MY FISH)
# https://github.com/oh-my-fish/oh-my-fish#installation
# https://github.com/oh-my-fish/plugin-thefuck
# omf install thefuck

function fish_user_key_bindings
  # ...
  bind \e\e 'thefuck-command-line'  # Bind EscEsc to thefuck
  # ...
end

# https://codeyarns.com/tech/2014-02-27-how-to-create-alias-in-fish.html#gsc.tab=0
function luck
  fuck
end

set PATH $PATH /home/linuxbrew/.linuxbrew/bin/
export PATH
# Arduino-CLI
set PATH $PATH "$HOME/bin/:$PATH"
# arduino-cli completion fish > arduino-cli.fish
# mkdir -p ~/.config/fish/completions/
# cp ~/bin/arduino-cli.fish ~/.config/fish/completions/
export PATH
# avrdude (for uploading HEX files to boards)
# ln -s ~/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/bin/avrdude ~/.local/bin/avrdude
export PATH="$HOME/.arduino15/packages/arduino/tools/avrdude/6.3.0-arduino17/bin/:$PATH"
export PATH

# PlatformIO Core CLI
export PATH="$HOME/.platformio/penv/bin/:$PATH"
export PATH

# $HOME/.local/bin
export PATH="$HOME/.local/bin/:$PATH"
export PATH

# $HOME/.cargo/bin
export PATH="$HOME/.cargo/bin:$PATH"
export PATH
