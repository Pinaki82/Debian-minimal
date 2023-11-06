# Working with RED R3D Camera footage and Blackmagic RAW files.

## RED R3D

**WARNING:**

---

Before executing the REDline installer script, it is recommended to run it within a virtual machine (VM) or take a backup of all data and the system using 'TimeShift'. Please note that it is advised to create a snapshot of the VM prior to running the script if you are testing the script within a VM. If the program works as expected without causing any issues with the OS in the test environment, the program can then be safely installed in the production environment. Unfortunately, upon installing REDline, the PulseAudio System Tray Plugin ceased to function and was automatically removed from the XFCE panel. As a result, MP3 and other audio files could not be played with any player application. Video editors typically anticipate an AppImage binary blob when working with proprietary software; however, this does not apply to RED Red Digital Cinema Camera Systems.

---

https://video.stackexchange.com/questions/12830/how-to-work-with-r3d-and-rmd-files-ffmpeg

Ans. 1:

> R3D files are essentially just a custom container that holds video encoded in JPEG2000 and PCM audio. Though ffmpeg only supports the RED container until version 3, not the newer version 4 (see this).
> 
> You can convert RED version **3** files the same way you 
> would convert any other video with ffmpeg.
> F.e. to h264 use the command below. Doesn't make much sense though to 
> use h264 for further editing, you will have to use an intermediate codec
>  and or container that your software supports:
> 
> ```bash
> ffmpeg -i input.r3d -vcodec libx264 -preset slow output.mp4
> ```

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

**NOTE:** Give FFMPEG a try before installing any software provided by camera manufacturers.

Download REDline: https://www.red.com/download/redline-linux-beta

Dependencies:

LSB support: https://unix.stackexchange.com/questions/545540/debian-unable-to-install-lsb-package

```bash
sudo apt install lsb-release
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
