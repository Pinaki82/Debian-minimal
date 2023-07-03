### Check the last reboot via the Command Prompt (MS Windows 10 or above):

[See here for more info](https://windowsreport.com/windows-server-check-last-reboot/#:~:text=Follow%20these%20steps%20to%20check%20the%20last%20reboot,see%20the%20last%20time%20your%20PC%20was%20rebooted.).

1. Open `Event Viewer` from the `Start Menu`:

`Windows Start Menu` -> `Event Viewer`

2. In the far right pane, select `Create Custom View`.

3. `Logged:` Drop-down menu -> `Last 30 days`.

4. `By log`     |   `Event Logs:` -> Drop-down menu -> `Windows Logs` (`Check`)

5. Under the `<All Event IDs>`, add `6009`.

6. Press `OK`.

7. `Name:` Change `New View` to `Boot Time`

8. Press `OK`.

9. See the last 10 "Boot Time" events that took place within the past 30 days from the Event Viewer's far left pane:
   
   `Windows Start Menu` -> `Event Viewer` -> `Custom Views` -> `Boot Time`

The LAST Boot Time via the Command Prompt (NOTE: Only the "LAST" boot time):

```
systeminfo | find /i "Boot Time"
```

Or,

```
systeminfo | find "System Boot Time" | more
```
