## Reduce SSD Wear n Tear:

DuckDuckGo: optimize ssd linux

References:

https://easylinuxtipsproject.blogspot.com/p/ssd.html

[ssd - Is TRIM enabled on my Ubuntu 18.04 installation? - Ask Ubuntu](https://askubuntu.com/questions/1034169/is-trim-enabled-on-my-ubuntu-18-04-installation)

[filesystem - Error message enabling fstrim.service - Ask Ubuntu](https://askubuntu.com/questions/1424869/error-message-enabling-fstrim-service)

### BIOS and UEFI: Make sure it's set to AHCI

Create **EXT4** partition/s during the OS installation.

**A.**

```
sudo mkdir -v /etc/systemd/system/fstrim.timer.d
```

```
sudo touch /etc/systemd/system/fstrim.timer.d/override.conf
```

```
mousepad admin:///etc/systemd/system/fstrim.timer.d/override.conf
```

Or, (if it doesn't do the trick)

```
sudo mousepad /etc/systemd/system/fstrim.timer.d/override.conf
```

Paste the following lines:

```
[Timer]
OnCalendar=
OnCalendar=daily
```

Check for the output:

```
sudo systemctl enable fstrim.service
```

```
sudo systemctl start fstrim
```

```
journalctl -u fstrim.service
```

**Reboot.**

**B.**

```
systemctl cat fstrim.timer
```

Approx. output:

```
yourusername@yourusername-H81M-WW:~$ systemctl cat fstrim.timer
# /lib/systemd/system/fstrim.timer
[Unit]
Description=Discard unused blocks once a week
Documentation=man:fstrim
ConditionVirtualization=!container

[Timer]
OnCalendar=weekly
AccuracySec=1h
Persistent=true

[Install]
WantedBy=timers.target

# /etc/systemd/system/fstrim.timer.d/override.conf
[Timer]
OnCalendar=
OnCalendar=daily

yourusername@yourusername-H81M-WW:~$ 
```

Do a sanity check.

```
journalctl | grep fstrim.service
```

```
systemctl status fstrim.service
```

```
Jun 21 18:32:11 yourusername-H81M-WW systemd[1]: fstrim.service: Succeeded.
Sep 15 10:54:10 yourusername-H81M-WW systemd[1]: fstrim.service: Succeeded.
Sep 16 15:44:44 yourusername-H81M-WW systemd[1]: fstrim.service: Succeeded.
```

```
systemctl status fstrim.timer
```

Output:

```
● fstrim.timer - Discard unused blocks once a week
     Loaded: loaded (/lib/systemd/system/fstrim.timer; enabled; preset: enabled)
    Drop-In: /etc/systemd/system/fstrim.timer.d
             └─override.conf
     Active: active (waiting) since Tue 2023-07-04 15:40:18 IST; 20min ago
      Until: Tue 2023-07-04 15:40:18 IST; 20min ago
    Trigger: Wed 2023-07-05 01:02:34 IST; 9h left
   Triggers: ● fstrim.service
       Docs: man:fstrim

Jul 04 15:40:18 debian-myusername systemd[1]: Started fstrim.timer - Discard unused b>
```

Is it working?

Test with one (unrelated) command:

```
xterm -ls -xrm 'XTerm*selectToClipboard: true'&
```

**C.**

Execute TRIM on-demand:
(Perform regularly)

```
sudo fstrim -av
```

The output should look somewhat like this:

```
yourusername@yourusername-H81M-WW:~$ sudo fstrim -av
[sudo] password for yourusername: 
/boot/efi: 234.1 MiB (245419008 bytes) trimmed on /dev/sda1
/: 2 GiB (2110889984 bytes) trimmed on /dev/sda2
yourusername@yourusername-H81M-WW:~$ 
```

Then, do

```
sudo fstrim -v /
```

Output:

```
yourusername@yourusername-H81M-WW:~$ sudo fstrim -v /
/: 157.8 MiB (165457920 bytes) trimmed
yourusername@yourusername-H81M-WW:~$ 
```

For your convenience in the future, create a shell file `ssd_trim.sh` with the following content:

```
#!/bin/bash

sudo fstrim -av && \
sudo fstrim -v /  \
```

First, check your current swap setting:

```
cat /proc/sys/vm/swappiness
```

Press Enter.

The result should probably be `60`.

```
mousepad admin:///etc/sysctl.conf
```

Or, (in case, if it doesn't work)

```
sudo mousepad /etc/sysctl.conf
```

Add the following lines, at the very end of the existing text in that file:

```
# Reduce the inclination to swap
vm.swappiness=10
```

**Reboot** the system.

===

Firefox:

`about:config`

`browser.cache.disk.enable`

Toggle its value to `false`

`browser.cache.memory.enable`

Toggle its value to `true` (if it's not already set there)

`browser.cache.memory.capacity`

Change the value to `524288` (512MB) or `1048576` (1GB) from `-1`

`about:cache`

`about:config`

`sessionstore`

`browser.sessionstore.interval`

The default interval is `15000`, which means 15 seconds. Append three zeros, so that it becomes: `15000000` and click the OK button.

`15000000`

Not essential & obsolete:

```
sudo sed -i 's/ errors=remount-ro/ noatime,errors=remount-ro/' /etc/fstab
```

If you have a separate partition for `/home`, then do the following also:

```
sudo sed -i 's/ defaults/ noatime,defaults/' /etc/fstab
```

**V. V. Important**

⋄ Always maintain _more than_ `20%` **free space** on _each_ partition.

𐚭 Keep SSD partitions as much blank and clean as possible. Never ever overload an SSD.
