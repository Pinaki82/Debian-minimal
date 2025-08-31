## [Xfce suddenly looses all my cusomizations in the whisker menu](https://forum.xfce.org/viewtopic.php?id=12569)

DDG AI Assist:

To prevent favourites in the XFCE Whisker menu from resetting, ensure that you are saving your changes correctly in the configuration files located in `~/.config/xfce4/panel/whiskermenu-8.rc`. If issues persist, you may need to reinstall the Whisker menu plugin or reset the panel settings. [ forum.endeavouros.com](https://forum.endeavouros.com/t/whisker-menu-reload/3135) [ forums.opensuse.org](https://forums.opensuse.org/t/editing-xfce-menu-to-remove-favorites-and-recently-used/136713)

## Issue with Favorites in XFCE Whisker Menu

### Common Causes

- **Configuration Files**: The favorites in the Whisker Menu may reset due to changes in configuration files located in `~/.config/xfce4/panel/`. If these files are deleted or corrupted, it can lead to the loss of favorites.

- **Updates or Bugs**: Sometimes, system updates or bugs can cause the favorites to disappear or reset. This is often reported by users after an update.

### Solutions

1. **Restore Configuration**:
   
   - Open a terminal and run the following commands to reset the panel configuration:

Code

- `rm -rf ~/.config/xfce4/panel rm -rf ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml`

- After executing these commands, restart the panel with:

Code

- - `xfce4-panel`

- **Reinstall Whisker Menu**:
  
  - If the issue persists, consider reinstalling the Whisker Menu plugin. Use the command:

Code

1. - `sudo apt-get install --reinstall xfce4-whiskermenu-plugin`

2. **Check for Updates**:
   
   - Ensure your system is up to date. Sometimes, newer versions fix bugs related to the menu.

### Preventive Measures

- **Backup Configuration**: Regularly back up your configuration files in `~/.config/xfce4/panel/` to restore them easily if needed.

- **Monitor Changes**: Be cautious when making changes to system settings or installing new software that might affect the XFCE environment.

By following these steps, you can address the issue of favorites resetting in the XFCE Whisker Menu.

 [ GitHub](https://github.com/QubesOS/qubes-issues/issues/6487) [ forums.opensuse.org](https://forums.opensuse.org/t/editing-xfce-menu-to-remove-favorites-and-recently-used/136713)

---

`~/.config/xfce4/panel/whiskermenu-7.rc`

R-click -> Owner & Group -> Read & Write

R-click -> Others -> Read Only
