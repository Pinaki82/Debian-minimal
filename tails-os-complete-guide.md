# Tails OS: A Comprehensive Guide to Privacy and Digital Security

## Overview: What is Tails?

Tails (The Amnesic Incognito Live System) is a privacy-focused, Debian-based operating system designed to protect user anonymity and digital security. By routing all internet traffic through the Tor network and operating entirely from a USB drive, Tails provides a powerful solution for individuals seeking to minimise their digital footprint.

## Key Features and Benefits

### Comprehensive Privacy Protection

- **Tor Network Integration**: All internet traffic is routed through Tor, ensuring anonymity and bypassing potential surveillance
- **Leave No Trace**: The operating system runs entirely from RAM and does not write data to the host computer's hard drive
- **Built-in Privacy Tools**: Includes metadata removal utilities, secure communication applications, and encryption tools. Even utilities for editing office documents, images, and vectors are included.

### Use Cases and Target Users

#### High-Risk Scenarios

- **Activists and Journalists**: Protect identities and secure communication in regions with restricted press freedoms and suppressed freedom of expression
- **Violence Survivors**: Escape digital surveillance and protect personal information. Individuals who are surrounded by antagonistic people who, if they obtain the disclosed information, could jeopardise their security, privacy, or lives.
- **Individuals Under Oppressive Regimes**: 
  - Bypass internet censorship
  - Deflect government overreach and political persecution by an oppressive regime
  - Communicate securely without risking government interception
  - Access blocked websites and resources
  - Protect against digital tracking and potential retaliation
  - Keep data safe from malevolent actors (hackers, for example)
  - Minimise digital evidence of online activities

> "If you look at the way post-2013 whistleblowers have been caught, it is clear the absolute most important thing you can do to maintain your anonymity is reduce the number of places in your operational activity where you can make mistakes. Tor and Tails still do precisely that." 
> — Edward Snowden, NSA Whistleblower

> "One of the most robust ways of using the Tor network is through a dedicated operating system that enforces strong privacy- and security-protective defaults. That operating system is Tails."
> — EFF, Electronic Frontier Foundation

The good news is that Tails is accessible from any host machine such as those found in libraries and internet cafés, with the right CPU architecture (Intel x86, ARM, RISC-V etc.), provided the USB stick is ready at hand.

## Download TailsOS using BitTorrent Protocol

Download the .torrent (e.g., `tails-amd64-x.yz.img.torrent`) into `$HOME/Downloads` from your browser. Use the Transmission BitTorrent client to download the OS image.

A folder containing the image (e.g., `tails-amd64-x.yz.img`) and the PGP SIGNATURE of the image (e.g., `tails-amd64-x.yz.img.sig`) will be downloaded.

Also, download the GPG/OpenPGP signing key from https://tails.net/tails-signing.key: 

The file is: `tails-signing.key`.

```bash
cd $HOME/Downloads
wget https://tails.net/tails-signing.key
```

## Verify Your Download Using the OpenPGP Signature

> Referenced:
> 
> https://www.thinkpenguin.com/gnu-linux/verifying-usb-flash-drive-contains-authentic-copy-tails
> 
> https://itsfoss.community/t/verifying-tails-iso/7946
> 
> https://tails.net/install/expert/index.en.html

```bash
cd $HOME/Downloads/
gpg --import < tails-signing.key
```

Note down the GPG key ID on a piece of paper (e.g., `DXX802X258PQR84F`). In our instance, it is: DBB802B258ACD84F). Please note that I'm importing the key for the second time.

```
gpg: key DBB802B258ACD84F: 2170 signatures not checked due to missing keys
gpg: key DBB802B258ACD84F: "Tails developers (offline long-term identity key) <tails@boum.org>" not changed
```

Install Debian Keyring:

```bash
sudo apt update && sudo apt install debian-keyring
```

Import the OpenPGP key of Chris Lamb, a former Debian Project Leader, from the Debian keyring, into your keyring:

```bash
gpg --keyring=/usr/share/keyrings/debian-keyring.gpg --export chris@chris-lamb.co.uk | gpg --import
```

Verify the certifications on the Tails signing key:

```bash
gpg --keyid-format 0xlong --check-sigs A490D0F4D311A4153E2BB7CADBB802B258ACD84F
```

In the output of this command, look for the following line:

```
sig!2        0x1E953E27D4311E58 2020-03-19  Chris Lamb <chris@chris-lamb.co.uk>
```

Here, `sig!2` means that Chris Lamb verified and certified the Tails signing key with his key and a level 2 check.

It is also possible to verify the certifications made by other people. Their name and email address appear in the list of certifications if you have their key in your keyring.

Certify the Tails signing key with your own key:

```bash
gpg --lsign-key A490D0F4D311A4153E2BB7CADBB802B258ACD84F
```

### Verify the Image File's Integrity Using GnuPGP:

```bash
gpg --verify tails-amd64-x.yx.img.sig
```

The output should somewhat look like this:

```
gpg: Signature made Wednesday 08 January 2025 05:48:24 PM IST
gpg:                using EDDSA key ADA2EDA956C296A70A6D7FF4FE2C600D5BB759B5
gpg: Good signature from "Tails developers (offline long-term identity key) <tails@boum.org>" [unknown]
gpg:                 aka "Tails developers <tails@boum.org>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: A490 D0F4 D311 A415 3E2B  B7CA DBB8 02B2 58AC D84F
     Subkey fingerprint: ADA2 EDA9 56C2 96A7 0A6D  7FF4 FE2C 600D 5BB7 59B5
```

Also, verify the image file using their online tool: https://tails.net/install/linux/index.en.html#verify

## Burn the Image to the USB Thumb Drive

- Start GNOME Disks (aka "Disks")
  
  For example, you can press the Super (WINDOWS) key, then type disks and choose "Disks".
  
  ![](https://tails.net/install/inc/icons/gnome-disks.png)

- Plug in the USB stick

- Click on drive options and choose **Restore Disk Image**:
  
  - A new drive appears in the left pane. Click on it.
  
  ![](https://tails.net/install/inc/screenshots/gnome_disks_drive.png)
  
  - Click on the ![Drive Options](https://tails.net/lib/view-more.png) button in the title bar and choose **Restore Disk Image**.
  
  ![](https://tails.net/install/inc/screenshots/gnome_disks_menu.png)
  
  - In the Restore Disk Image dialogue, click on the file selector button. Choose the USB image that you downloaded earlier.

- Ensure the image has an `.img` extension. If the image has an *.iso* file extension, it is the wrong image.

## Configure Tails to Your Liking

Boot from the Tails live USB drive and configure basic settings initially.

Once you're back to your regular Linux installation, follow these steps.

Insert the USB drive and mount its _persistent storage_ using the password you set for it while setting up Tails for the first time.

Then, access the _persistent storage_ with administrator privilege using your file manager. On my Debian XFCE machine, the file manager is Thunar.

```bash
sudo thunar
```

Navigate to persistent storage:

```bash
cd /media/$(whoami)/TailsData/Persistent/Tor Browser/
```

From the GUI file manager's address bar, it should be something like:

```
/media/YOURUSERNAME/TailsData/Persistent/Tor Browser/
```

The files you saved while using Tails OS are located here.

**Note:** Recommended to use a separate encrypted volume for data storage. I suggest that you leave persistent storage empty and store data on another LUKS (Linux Unified Key Setup) or VeraCrypt encrypted volume from another USB flash drive while running the operating system. Tails includes facilities for accessing VeraCrypt volumes.

### The Tails Configuration File

```bash
/media/$(whoami)/TailsData/persistence.conf
```

Navigate to `/media/YOURUSERNAME/TailsData` and edit the config if needed.

Sample configuration:

```
/etc/NetworkManager/system-connections    source=nm-system-connections
/home/amnesia/.gnupg    source=gnupg
/home/amnesia/.mozilla/firefox/bookmarks    source=bookmarks
/home/amnesia/Persistent    source=Persistent
/var/cache/apt/archives    source=apt/cache
/var/lib/apt/lists    source=apt/lists
```

1. `/etc/NetworkManager/system-connections    source=nm-system-connections` implies that you allowed Tails to connect to the internet.

2. `/home/amnesia/.gnupg; source=gnupg` suggests that you wish to use GnuPG (GPG), the GNU implementation of the OpenPGP encryption protocol in Tails. It is commonly used to validate digital evidence in court, sign documents, sign code commits to GIT repositories, and encrypt private messages and files. You will need to either transfer your existing GPG identity into Tails or establish a new one and back it up. **Tip:** Use another USB thumb drive.

3. Bookmarks, `/home/amnesia/.mozilla/firefox    source=bookmarks` indicates that you permitted Tor Browser, Tails OS's built-in browser based on Mozilla Firefox, to store your bookmarks.
   
   > **NOTE:** Avoid storing bookmarks in Tails unless it is absolutely necessary. For instance: Only a small number of search engines' onion versions should be bookmarked. Depending on the threatening circumstances, the excess could prove to be fatal. You can keep your bookmarks in a text file on your encrypted second USB thumb drive or even in an encrypted KeePassXC database. KeePassXC is included with Tails.

4. The configuration of `/home/amnesia/Persistent source=Persistent` indicates that you have set up Tails to have persistent storage. It is generally advised that high-value targets refrain from storing data within Tails OS since the benefits of plausible denial factors are undermined if the attacker gains physical access to your Tails USB drive.

5. It is implied that you permitted Tails to store installer archives in *.deb containers in case you install other software packages on Tails by setting `/var/cache/apt/archives source=apt/cache`. It is the default configuration. You don't have to be concerned.

6. `/var/lib/apt/lists` Default configuration. I'm not entirely certain.

## Security Best Practices

- Minimise bookmarks
- Use KeePassXC for credential management
- Avoid storing sensitive data directly in Tails
- Regularly rotate storage media
- Understand potential digital traces
- ⭐ Last but not least, **bind your Tails USB drive to your hand** with a thin metal chain or a rope. You can **remove your Tails OS USB drive** from the system's USB port **along with yourself** in the event an attacker attempts to physically gain access to it.

## Conclusion

Tails OS provides a robust solution for maintaining digital privacy, especially in high-risk environments or under oppressive surveillance.
