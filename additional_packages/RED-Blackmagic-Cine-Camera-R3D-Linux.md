# Working with RED R3D Camera footage and Blackmagic RAW files.

## RED R3D

**WARNING:**

> WARNING: Try the installer in a VM or backup everything before running the installer script. If it works in the test environment, install the program in the production environment. PulseAudio System Tray Plugin stopped working and was automatically removed from the panel after installing REDline. MP3 and other audio files could not be played with any player application after installing REDline.

https://video.stackexchange.com/questions/12830/how-to-work-with-r3d-and-rmd-files-ffmpeg

Ans. 1:

> R3D files are essentially just a custom container that holds video encoded in JPEG2000 and PCM audio. Though ffmpeg only supports the RED container until version 3, not the newer version 4 (see this).

Ans. 2:

> You can use red official program "REDline" Download It from here https://www.red.com/download/redline-linux-beta

> It's a shell script. to install it. From properties change it's permission to allow execute.

> chmod +x REDline_Build_60.52530_Installer.sh
> sudo ./REDline_Build_60.52530_Installer.sh

> normally you can convert R3D (red video files to other formats like openexr,tiff , jpeg ) files to image sequences and also you extract audio too.

> Now if i want to convert a R3D files to jpeg sequences the command would be like this

> $ REDline -i <filelocation/file.R3D> --format 3 -o filename

> let me explain what are these commands and options are

> here REDline is our program for converting R3D files to image sequences

> -i means video for converting

> --format 3 means convert to what format currently the program supports DPX , Tiff, OpenEXR , JPEG, SGI, R3D Trim, Apple ProRes and Avid DNX formats. now what does 3 means 3 means convert R3D files to image sequences. so how can you convert to Tiff format use number 1. for other formats you can use

> DPX = 0, OpenEXR = 2, SGI = 4, R3D Trim = 102, Apple ProRes=201, Avid DNX = 204

> -o means output file name because you are converting to jpeg image sequences the program will automatically name it.like wise

> filename.000000.jpg
> filename.000001.jpg
> filename.000002.jpg
> filename.000003.jpg

Download REDline: https://www.red.com/download/redline-linux-beta

Dependencies:

LSB support: https://unix.stackexchange.com/questions/545540/debian-unable-to-install-lsb-package

```bash
sudo apt install lsb-base lsb-release
```

```bash
chmod +x REDline_Build_60.52530_Installer.sh
```

```bash
sudo ./REDline_Build_60.52530_Installer.sh
```

```bash
REDline -i <filelocation/file.R3D> --format 3 -o filename
```

## Blackmagic RAW:

https://www.blackmagicdesign.com/event/blackmagicrawinstaller
