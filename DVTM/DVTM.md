# DVTM

![DVTM-Terminal-Windows](https://user-images.githubusercontent.com/16861933/179930206-d944ef4b-317c-4baf-81b3-beb70fc2a116.png)

```
sudo apt install dvtm
```

Depends on _libncurses_. Takes up 5MB (approx.) HDD space.

## A Tiling Window Manager in the Console. Inspired by [DWM](https://dwm.suckless.org/tutorial/).

https://www.brain-dump.org/projects/dvtm/

DVTM differs from the regular DWM.

The key combinations outlined in the following links will not work.

https://gist.github.com/erlendaakre/12eb90eef84a3ab81f7b531e516c9594

https://www.pkimber.net/howto/linux/suckless/shortcuts.html

Still, it's good to have a mental map of the Keybindings of DWM in its default configuration.

## What's the purpose?

In case your antiquated PC’s/Laptop’s OpenGL driver IC gets damaged (^_^), or you’ve installed Ubuntu Server and plan to use it without a GUI.

🛑 WARNING: NO <GIMP/INKSCAPE/KDENLIVE/BLENDER> ZONE. 🛑

![Screencapture](https://raw.githubusercontent.com/martanne/dvtm/gh-pages/screencast.gif#center)

# Usage Guide:

## MOD Key

`CTRL`+`g` == `MOD` (The **MOD** Key)

Press 'CTRL' and the small case 'g' simultaneously.

Think of it as an initiator that lets us take advantage of key combinations.

So, `MOD` means `CTRL+g`.

## Let's start.

Fire up any _Terminal Emulator_.

Type `bash`

Type `dvtm`

## Initiate

Initiate **DVTM** with **MOD** (the key combination `CTRL+g`)

## Keybindings

Type `c`

At this stage, you have split the window (screen-zone) vertically.

## Exiting DVTM

`MOD` `q`

Or `MOD` `q` `q` will let you **exit** DVTM.

## Closing a Window

`MOD` `x`

Or `MOD` `x` `x` will let you **close** a window.

## The Next Window

Let's switch to the next window.

`MOD`. Then, `j`

Or

`MOD`. Then, `k`

`j` means 'the next window'. `k` means the previous window.

## Be Specific

Look at the _window numbers_ (not a different workspace).

`MOD`. Then, `1` to `9`

It will take you to a specific window.

## Minimise & Restore

Minimise a particular window and restore it.

Go over to that window (by looking at its number)

`MOD`. Then `.`

Minimised.

Restore it.

`MOD`, then, `MOD` plus 'the tag-number of the minimised window'.

That is,

`CTRL`+`g` -> `.`

`CTRL`+`g` -> 1 to 9

## Mirror Your Keystrokes

`MOD`+`a` will type the same keystrokes in every other window. **Not very useful** (IMHO).

## Enlarge or Shrink

Enlarge or Shrink the window area.

`MOD`, then, `h`

Or, `MOD`, then, `l`

## The Master Area

Window number `#1` is the **Master Area**.

#### Let me copy-paste it from their website.

Look at what their website says. I didn't understand such a complex convention.

`MOD` then `Enter` will zoom all other windows into the master area (presumably).

### Increase or Decrease the Windows in the Master Area

The number of windows in the master area can be increased and decreased with `MOD`+`i` and `MOD`+`d`.

## Fullscreen

`MOD`, then, `M` will make the currently active area fullscreen.

## Cycle Through the Windows

`MOD` then `i`

`MOD`+`Space` will let you cycle through the windows.

## Tagging:

`MOD`-`0` view all windows with any tag

`Mod`-`v`-`Tab` toggles to the previously selected tags

`MOD`-`v`-[1..n] view all windows with nth tag

`MOD`-`V`-[1..n] add/remove all windows with nth tag to/from the view

`MOD`-`t`-[1..n] apply nth tag to focused window

`MOD`-`T`-[1..n] add/remove nth tag to/from focused window

### A Small Tip:

That means `MOD` `v` `2` will take you to the window-tag (workspace) 2. Think of it as a kind of **Workspace**.

## See it in Action and Learn

Watch the GIF screen capture to get an overview. It's from their website.

![Screencapture](https://raw.githubusercontent.com/martanne/dvtm/gh-pages/screencast.gif#center)

Practise it a couple of times.
