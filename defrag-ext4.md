## 😄 :D 😝

# Do Ext4 (journaling file system) drives need defragmentation?

---

**TL;DR:** _NO_, **unless** there's **less than 20% space** left. In such cases, fragmentation levels may sometimes exceed 20%.

**NOTE:** Also, SSDs (3.5" SSDs, NVMe drives, Pen Drives, etc.) never require defragmentation. Attempting to defragment them can actually shorten their lifespan. Please avoid doing that.

---

DDG Search: do ext4 drives need defragmentation

Response: Ext4 file systems are designed to minimize fragmentation, making defragmentation generally unnecessary in most cases. However, if fragmentation levels exceed 20%, it may be beneficial to use tools like `e4defrag` to improve performance.

https://superuser.com/questions/536788/do-ext4-filesystems-need-to-be-defragmented#536797

> You can run e2fsck to check how heavily your partition is fragmented. On mounted partitions, this will spew a ton of errors, please disregard them:
> 
> `sudo e2fsck -n -v -f /dev/partition`

Example output:

```bash
e2fsck 1.47.0 (5-Feb-2023)
Warning!  /dev/sdb1 is mounted.
Warning: skipping journal recovery because doing a read-only filesystem check.
Pass 1: Checking inodes, blocks, and sizes
Inode 17 extent tree (at level 2) could be narrower.  Optimize? no

Inode 24643838 extent tree (at level 1) could be shorter.  Optimize? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (145170566, counted=145095145).
Fix? no

Free inodes count wrong (121746599, counted=121746596).
Fix? no


      346969 inodes used (0.28%, out of 122093568)
       13486 non-contiguous files (3.9%)
          87 non-contiguous directories (0.0%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 345647/1272/1
   343196254 blocks used (70.27%, out of 488366820)
           0 bad blocks
          39 large files

      310850 regular files
       36058 directories
           0 character device files
           0 block device files
           0 fifos
           0 links
          55 symbolic links (44 fast symbolic links)
           0 sockets
------------
      346963 files
```

https://askubuntu.com/questions/221079/how-to-defrag-an-ext4-filesystem#620966

> Use e4defrag to defrag your files
> 
> If your ext4 file system is created with the extent option (it's the default in recent distros), you can use the e4defrag utility to check and defragment it online, i.e. without umounting.
> 
> Just check fragmentation level with something like this (you need to be root to see details):
> 
> `sudo e4defrag -c /path/to/myfiles`

Example output:

```
sudo e4defrag -c /mnt/hdd/
e4defrag 1.47.0 (5-Feb-2023)
<Fragmented files>                             now/best       size/ext
1. /mnt/hdd/.Trash-1000/expunged/639221905/001/recup_dir.1/report.xml
                                                 4/1              4 KB
2. /mnt/hdd/.Trash-1000/expunged/351247357/recup_dir.1/report.xml
                                                17/1              5 KB
3. /mnt/hdd/HOME/code/editready/.git/logs/refs/heads/main
                                                 3/1              4 KB
4. /mnt/hdd/HOME/code/editready/.git/logs/HEAD
                                                 3/1              4 KB
5. /mnt/hdd/HOME/code/cpp_putty_plus/.git/logs/refs/heads/main
                                                 3/1              4 KB

 Total/best extents                340069/310522
 Average size per extent            3943 KB
 Fragmentation score                0
 [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
 This directory (/mnt/hdd/) does not need defragmentation.
 Done.
```

---

Check the fragmentation level:

```bash
lsblk | grep 'sd'
```

Example output:

```bash
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
sdd      8:48   1  28.7G  0 disk 
└─sdd1   8:49   1  28.7G  0 part /media/myusername/8284-AC69
```

Check by issuing:

```bash
sudo e2fsck -n -v -f /dev/partition
```

Example:

```bash
sudo e2fsck -n -v -f /dev/sdb1
```

Or,

```bash
sudo e4defrag -c /path/to/myfiles
```

Example:

```bash
sudo e4defrag -c /mnt/hdd/Resources_3 (foldername with path)
```
