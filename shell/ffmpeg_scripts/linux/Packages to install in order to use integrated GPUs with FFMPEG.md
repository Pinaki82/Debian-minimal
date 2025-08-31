# Packages to install in order to use integrated GPUs with FFMPEG

Add this custom entry to either your `.bash_aliases` or `.bashrc`:

```bash
# Older Intel iGPUs, the 4th generation of Intel Core processors
# Product code: 80646 (desktop LGA 1150), 80647 (mobile Socket G3), 80648 (desktop LGA 2011-3), 80644 (server LGA 2011-3)
# Socket(s): LGA 1150, rPGA 947, BGA 1364, BGA 1168, LGA 2011-v3
# Force VAAPI to Use i965 for FFMPEG on older Haswell Bridge Intel CPUs:
export LIBVA_DRIVER_NAME=i965
```

Here’s a refined, practical guide you can share. It covers two scenarios:

---

## 1) \*\* Older Intel Haswell or Pre‑Broadwell Machines\*\*

These systems need the legacy **i965 driver**, but newer VA‑API libraries may conflict.

### Recommended Steps:

# 1. Remove the unsupported iHD driver

```bash
sudo apt purge --auto-remove intel-media-va-driver*
```

# 2. Install the legacy driver and necessary tools

```bash
sudo apt install i965-va-driver vainfo libva-drm2 libva-x11-2
```

# 3. (Optional) Reboot or logout/login

Then test VA‑API with:

```bash
LIBVA_DRIVER_NAME=i965 \
ffmpeg -hide_banner -loglevel info \
  -f lavfi -i testsrc2 -frames 10 \
  -vaapi_device /dev/dri/renderD128 \
  -vf 'format=nv12,hwupload' -c:v h264_vaapi -f null -
```

**Note:** If you see:

```bash
undefined symbol: vaMapBuffer2
```

or an assertion failure, then your installed `libva2` is incompatible with `i965`. In that case, VA‑API encoding likely won't work without downgrading to an older `libva` version—often impractical and fragile.

**Bottom line:** Just mark VA‑API as *present but unusable*, and fall back to software encoding (`libx264`) on Haswell.

---

## 2) **Newer Intel / AMD (Broadwell and Later) or Linux Systems**

Modern hardware uses the newer **intel-media-va-driver** (iHD) for VA‑API or Mesa-based drivers for AMD.

### Intel (Broadwell and newer):

```bash
sudo apt install intel-media-va-driver vainfo libva-drm2 libva-x11-2
```

# Test with:

```
ffmpeg -hide_banner -loglevel info \
  -f lavfi -i testsrc2 -frames 10 \
  -vaapi_device /dev/dri/renderD128 \
  -vf 'format=nv12,hwupload' -c:v h264_vaapi -f null -
```

If no errors and you get frames encoded, then VA‑API encoding works!

### AMD GPUs:

```bash
sudo apt install mesa-va-drivers vainfo libva-drm2 libva-x11-2
```

Test similarly with `ffmpeg`. VA‑API is typically supported via Mesa on Radeon hardware.

---

## Summary Table

| Machine Type              | Install Driver                | Test Command | Outcome                 |
| ------------------------- | ----------------------------- | ------------ | ----------------------- |
| Older Intel (Haswell)     | `i965-va-driver` (remove iHD) | `ffmpeg...`  | Likely fails—use `x264` |
| Modern Intel (Broadwell+) | `intel-media-va-driver` (iHD) | `ffmpeg...`  | Should work             |
| AMD GPU                   | `mesa-va-drivers`             | `ffmpeg...`  | Should work             |
