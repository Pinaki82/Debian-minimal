Using FFMPEG to record the entire screen in Linux.

TL;DR:

The command:

```bash
ffmpeg -y -rtbufsize 100M -f x11grab -framerate 25 -probesize 10M -draw_mouse 1 -s $(xdpyinfo | grep dimensions | awk '{print $2}') -i :0.0 -f pulse -i alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -c:v mjpeg -q:v 0 -r 25 -c:a pcm_s16le -pix_fmt yuv420p output.mov
```

---

**Gemini-2.5-pro. LMArena. 2025.10.04**

---

`ffmpeg -y -rtbufsize 100M -f x11grab -framerate 25 -probesize 10M -draw_mouse 1 -s $(xdpyinfo | grep dimensions | awk '{print $2}') -i :0.0 -c:v mjpeg -q:v 0 -crf 0 -preset ultrafast -r 25 -c:a pcm_s16le -tune zerolatency -pix_fmt yuv420p output.mov`

How to capture audio along with it?

Of course. Your command is excellent for capturing video, but it's missing an audio **input source**. You've specified an audio *codec* (`-c:a pcm_s16le`), but you haven't told FFmpeg *where* to get the audio from.
To capture audio, you need to add a second input (`-i`) specifying your audio device. On Linux, this is typically done using either **PulseAudio** (most common on modern desktops) or **ALSA** (the lower-level sound system).

---

### 1. The Quick Answer (Using PulseAudio)

PulseAudio is the easiest method. You first need to find the name of the audio source you want to record. This could be your microphone or the audio that your computer is playing (often called a "monitor" or "loopback" source).

#### Step 1: Find Your Audio Source Name

Open a terminal and run this command:

```bash
pactl list sources
```

You will get a lot of output. Look for the `Name:` and `Description:` fields. For example, you might see something like this for your microphone:

```
Source #1
 State: RUNNING
 Name: alsa_input.pci-0000_00_1f.3.analog-stereo
 Description: Built-in Audio Analog Stereo
 ...
```

And something like this for your system's output audio (what you hear in your speakers/headphones):

```
Source #2
 State: IDLE
 Name: alsa_output.pci-0000_00_1f.3.analog-stereo.monitor
 Description: Monitor of Built-in Audio Analog Stereo
 ...
```

The crucial part is the `Name:`. Copy the name of the source you want to record.

#### Step 2: Add the Audio Input to Your Command

Now, add the audio source to your FFmpeg command using `-f pulse` and a new `-i` flag.
Here is your original command modified to capture the **system's output audio** (using the monitor source from the example above).

```bash
ffmpeg -y -rtbufsize 100M \
-f x11grab -framerate 25 -probesize 10M -draw_mouse 1 -s $(xdpyinfo | grep dimensions | awk '{print $2}') -i :0.0 \
-f pulse -i alsa_output.pci-0000_00_1f.3.analog-stereo.monitor \
-c:v mjpeg -q:v 0 -r 25 \
-c:a pcm_s16le \
-pix_fmt yuv420p output.mov
```

**Changes Made:**

* **`-f pulse -i alsa_output.pci-0000_00_1f.3.analog-stereo.monitor`**: This tells FFmpeg to use the PulseAudio format (`-f pulse`) and capture from the device with that specific name (`-i ...`).
* **Removed Redundant Flags**: I removed `-crf 0`, `-preset ultrafast`, and `-tune zerolatency` as they are options for the `libx264` video codec, not `mjpeg`.

---

### 2. Recommended: A Modern Command for Better Quality & File Size

Your current command uses `-c:v mjpeg`, which creates **very large, uncompressed files**. For most uses, you'll want to use a modern codec like `libx264` (H.264) for video and `aac` for audio, which gives excellent quality at a much smaller file size.
This improved command does the following:

* Uses `libx264` for efficient video compression.

* Uses `aac` for efficient audio compression.

* Saves the output to a more common `.mp4` container.
  
  ```bash
  # Don't forget to replace 'YOUR_PULSE_DEVICE_NAME' with the one you found!
  # e.g., alsa_output.pci-0000_00_1f.3.analog-stereo.monitor
  ffmpeg -y \
  -f x11grab -framerate 25 -draw_mouse 1 -s $(xdpyinfo | grep dimensions | awk '{print $2}') -i :0.0 \
  -f pulse -i YOUR_PULSE_DEVICE_NAME \
  -c:v libx264 -preset veryfast -crf 22 \
  -c:a aac -b:a 192k \
  -pix_fmt yuv420p output.mp4
  ```
  
  **Explanation of the improved options:**

* `-c:v libx264`: The most widely used video codec. Great balance of quality and size.

* `-preset veryfast`: A good balance between encoding speed and file size. `ultrafast` gives a larger file, `slower` gives a smaller file but uses more CPU.

* `-crf 22`: The Constant Rate Factor. This controls the quality. A lower number means higher quality and a larger file. `18` is nearly visually lossless, `23` is a good default, and `28` is lower quality.

* `-c:a aac`: A very common and efficient audio codec.

* `-b:a 192k`: Sets the audio bitrate to 192 kbps, which is good quality for stereo audio.

* `output.mp4`: The MP4 container is more universally compatible than MOV.
  
  ### Summary
1. **Find your audio device name** with `pactl list sources`.
2. **Add a new input** to your FFmpeg command: `-f pulse -i <your_device_name>`.
3. **Consider using the recommended command** with `libx264` and `aac` for much smaller file sizes and better compatibility.

Your first command worked fine. Thanks!

Excellent! I'm glad to hear the first command worked for you.
For your future reference, here is the final command structure as a clean template. The key was adding the second input (`-f pulse -i ...`) to capture the audio stream alongside your screen capture.

### Your Working Command (Template)

**1. Find your audio source name:**

```bash
pactl list sources
```

(Look for the `Name:` field, e.g., `alsa_output.pci-0000_00_1f.3.analog-stereo.monitor`)
**2. Use it in the command:**

```bash
ffmpeg -y -rtbufsize 100M \
-f x11grab -framerate 25 -s $(xdpyinfo | grep dimensions | awk '{print $2}') -i :0.0 \
-f pulse -i YOUR_PULSE_AUDIO_SOURCE \
-c:v mjpeg -q:v 0 \
-c:a pcm_s16le \
-pix_fmt yuv420p output.mov
```

Just keep in mind what we discussed: this command produces very high-quality but extremely large files because `mjpeg` and `pcm_s16le` are essentially uncompressed. It's perfect for short clips or when you plan to edit the video later and need maximum quality.
If you ever need to record a longer session and are concerned about file size, the second command with `libx264` and `aac` will be your best bet.
Happy recording

---

Final command:

```bash
ffmpeg -y -rtbufsize 100M -f x11grab -framerate 25 -probesize 10M -draw_mouse 1 -s $(xdpyinfo | grep dimensions | awk '{print $2}') -i :0.0 -f pulse -i alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -c:v mjpeg -q:v 0 -r 25 -c:a pcm_s16le -pix_fmt yuv420p output.mov
```

---

`pactl` output:

```bash
pactl list sources
Source #42
    State: IDLE
    Name: alsa_output.pci-0000_00_1b.0.analog-stereo.monitor
    Description: Monitor of Built-in Audio Analog Stereo
    Driver: PipeWire
    Sample Specification: s32le 2ch 48000Hz
    Channel Map: front-left,front-right
    Owner Module: 4294967295
    Mute: no
    Volume: front-left: 65536 / 100% / 0.00 dB,   front-right: 65536 / 100% / 0.00 dB
            balance 0.00
    Base Volume: 65536 / 100% / 0.00 dB
    Monitor of Sink: alsa_output.pci-0000_00_1b.0.analog-stereo
    Latency: 0 usec, configured 0 usec
    Flags: HARDWARE DECIBEL_VOLUME LATENCY 
    Properties:
        alsa.card = "1"
        alsa.card_name = "HDA Intel PCH"
        alsa.class = "generic"
        alsa.device = "0"
        alsa.driver_name = "snd_hda_intel"
        alsa.id = "ALC887-VD Analog"
        alsa.long_card_name = "HDA Intel PCH at 0xf7d10000 irq 33"
        alsa.name = "ALC887-VD Analog"
        alsa.resolution_bits = "16"
        alsa.subclass = "generic-mix"
        alsa.subdevice = "0"
        alsa.subdevice_name = "subdevice #0"
        api.alsa.card.longname = "HDA Intel PCH at 0xf7d10000 irq 33"
        api.alsa.card.name = "HDA Intel PCH"
        api.alsa.path = "front:1"
        api.alsa.pcm.card = "1"
        api.alsa.pcm.stream = "playback"
        audio.channels = "2"
        audio.position = "FL,FR"
        card.profile.device = "4"
        device.api = "alsa"
        device.class = "monitor"
        device.id = "41"
        device.profile.description = "Analog Stereo"
        device.profile.name = "analog-stereo"
        device.routes = "2"
        factory.name = "api.alsa.pcm.sink"
        media.class = "Audio/Sink"
        device.description = "Built-in Audio"
        node.name = "alsa_output.pci-0000_00_1b.0.analog-stereo"
        node.nick = "ALC887-VD Analog"
        node.pause-on-idle = "false"
        object.path = "alsa:pcm:1:front:1:playback"
        priority.driver = "1009"
        priority.session = "1009"
        factory.id = "18"
        clock.quantum-limit = "8192"
        client.id = "33"
        node.driver = "true"
        factory.mode = "merge"
        audio.adapt.follower = ""
        library.name = "audioconvert/libspa-audioconvert"
        object.id = "42"
        object.serial = "42"
        node.max-latency = "16384/48000"
        api.alsa.period-size = "1024"
        api.alsa.period-num = "32"
        api.alsa.headroom = "0"
        api.acp.auto-port = "false"
        api.acp.auto-profile = "false"
        api.alsa.card = "1"
        api.alsa.use-acp = "true"
        api.dbus.ReserveDevice1 = "Audio1"
        device.bus = "pci"
        device.bus_path = "pci-0000:00:1b.0"
        device.enum.api = "udev"
        device.form_factor = "internal"
        device.icon_name = "audio-card-analog-pci"
        device.name = "alsa_card.pci-0000_00_1b.0"
        device.nick = "HDA Intel PCH"
        device.plugged.usec = "19005492"
        device.product.id = "0x8c20"
        device.product.name = "8 Series/C220 Series Chipset High Definition Audio Controller"
        device.subsystem = "sound"
        sysfs.path = "/devices/pci0000:00/0000:00:1b.0/sound/card1"
        device.vendor.id = "0x8086"
        device.vendor.name = "Intel Corporation"
        device.string = "1"
    Formats:
        pcm

Source #43
    State: SUSPENDED
    Name: alsa_input.pci-0000_00_1b.0.analog-stereo
    Description: Built-in Audio Analog Stereo
    Driver: PipeWire
    Sample Specification: s32le 2ch 48000Hz
    Channel Map: front-left,front-right
    Owner Module: 4294967295
    Mute: no
    Volume: front-left: 65536 / 100% / 0.00 dB,   front-right: 65536 / 100% / 0.00 dB
            balance 0.00
    Base Volume: 65536 / 100% / 0.00 dB
    Monitor of Sink: n/a
    Latency: 0 usec, configured 0 usec
    Flags: HARDWARE DECIBEL_VOLUME LATENCY 
    Properties:
        alsa.card = "1"
        alsa.card_name = "HDA Intel PCH"
        alsa.class = "generic"
        alsa.device = "0"
        alsa.driver_name = "snd_hda_intel"
        alsa.id = "ALC887-VD Analog"
        alsa.long_card_name = "HDA Intel PCH at 0xf7d10000 irq 33"
        alsa.name = "ALC887-VD Analog"
        alsa.resolution_bits = "16"
        alsa.subclass = "generic-mix"
        alsa.subdevice = "0"
        alsa.subdevice_name = "subdevice #0"
        api.alsa.card.longname = "HDA Intel PCH at 0xf7d10000 irq 33"
        api.alsa.card.name = "HDA Intel PCH"
        api.alsa.path = "front:1"
        api.alsa.pcm.card = "1"
        api.alsa.pcm.stream = "capture"
        audio.channels = "2"
        audio.position = "FL,FR"
        card.profile.device = "0"
        device.api = "alsa"
        device.class = "sound"
        device.id = "41"
        device.profile.description = "Analog Stereo"
        device.profile.name = "analog-stereo"
        device.routes = "3"
        factory.name = "api.alsa.pcm.source"
        media.class = "Audio/Source"
        device.description = "Built-in Audio"
        node.name = "alsa_input.pci-0000_00_1b.0.analog-stereo"
        node.nick = "ALC887-VD Analog"
        node.pause-on-idle = "false"
        object.path = "alsa:pcm:1:front:1:capture"
        priority.driver = "2009"
        priority.session = "2009"
        factory.id = "18"
        clock.quantum-limit = "8192"
        client.id = "33"
        node.driver = "true"
        factory.mode = "split"
        audio.adapt.follower = ""
        library.name = "audioconvert/libspa-audioconvert"
        object.id = "43"
        object.serial = "43"
        api.acp.auto-port = "false"
        api.acp.auto-profile = "false"
        api.alsa.card = "1"
        api.alsa.use-acp = "true"
        api.dbus.ReserveDevice1 = "Audio1"
        device.bus = "pci"
        device.bus_path = "pci-0000:00:1b.0"
        device.enum.api = "udev"
        device.form_factor = "internal"
        device.icon_name = "audio-card-analog-pci"
        device.name = "alsa_card.pci-0000_00_1b.0"
        device.nick = "HDA Intel PCH"
        device.plugged.usec = "19005492"
        device.product.id = "0x8c20"
        device.product.name = "8 Series/C220 Series Chipset High Definition Audio Controller"
        device.subsystem = "sound"
        sysfs.path = "/devices/pci0000:00/0000:00:1b.0/sound/card1"
        device.vendor.id = "0x8086"
        device.vendor.name = "Intel Corporation"
        device.string = "1"
    Ports:
        analog-input-front-mic: Front Microphone (type: Mic, priority: 8500, availability group: Legacy 1, not available)
        analog-input-rear-mic: Rear Microphone (type: Mic, priority: 8200, availability group: Legacy 2, not available)
        analog-input-linein: Line In (type: Line, priority: 8100, availability group: Legacy 3, not available)
    Active Port: analog-input-front-mic
    Formats:
        pcm
```