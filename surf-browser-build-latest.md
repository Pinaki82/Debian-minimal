# Installing Surf Browser from Source

This guide covers installing or upgrading Surf, a minimalist web browser from suckless.org.

https://surf.suckless.org/

## Prerequisites

The following packages are required:

- webkit2gtk-4.0
- gcr-3
- git

## Installation Steps

1. Install required dependencies:
   
   ```bash
   sudo apt install libwebkit2gtk-4.0-dev libgcr-3-dev
   ```

2. Clone the repository:
   
   ```bash
   git clone https://git.suckless.org/surf
   # Alternative: git clone https://github.com/mrdotx/surf.git
   ```

3. Navigate to the directory:
   
   ```bash
   cd surf
   ```

4. Build and verify:
   
   ```bash
   make
   chmod +x surf
   ./surf
   ```

5. Install:
   
   ```bash
   sudo make install
   make clean
   ```

## Updating Surf

To update to the latest version:

1. Pull the latest changes with `git pull`
2. Repeat the build and install steps above

## Troubleshooting

If you encounter a segmentation fault with your existing installation, following this installation process should resolve the issue. The newly compiled version can be tested before installation by running `./surf` from the build directory.
