# Defrag NTFS Volumes from Linux:

https://vleu.net/projects/shake/

https://github.com/unbrice/shake.git

> Shake is a defragmenter that runs in userspace, without the need of patching the kernel and while the system is used (for now, on GNU/Linux only).
> 
> There is nothing magic in that : it just works by rewriting fragmented files. But it has some heuristics that could make it more efficient than other tools, including defrag and, maybe, xfs_fsr.

See: https://askubuntu.com/questions/59007/defragging-ntfs-partitions-from-linux#59011

```bash
apt search help2man
sudo apt install help2man
sudo apt install libattr1-dev
```

```bash
git clone https://github.com/unbrice/shake.git
cd shake
cd build
cmake ..
make
sudo make install
```

Usage:

Open "GNOME Disks", or:

```bash
lsblk | grep 'sd'
```

```
sda      8:0    0 223.6G  0 disk 
├─sda1   8:1    0 222.6G  0 part /
├─sda2   8:2    0     1K  0 part 
└─sda5   8:5    0   975M  0 part 
sdb      8:16   0   1.8T  0 disk 
├─sdb1   8:17   0   1.8T  0 part /mnt/hdd
├─sdb2   8:18   0    32M  0 part 
└─sdb3   8:19   0   512B  0 part 
sdc      8:32   0 238.5G  0 disk 
└─sdc1   8:33   0 238.5G  0 part /mnt/hdd2
sdd      8:48   1   7.3G  0 disk 
└─sdd1   8:49   1   7.3G  0 part /media/myusername/drivename
```

Defrag a single directory:

```bash
sudo shake --pretend --verbose --verbose my_dir
```

Defrag an entire MS Windows drive:

```bash
sudo shake --pretend --verbose --verbose /media/myusername/drivename
```
