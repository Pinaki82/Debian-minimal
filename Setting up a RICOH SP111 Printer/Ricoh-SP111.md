# Setting up a RICOH SP111 Printer

**Brave search:** _ricoh sp111 driver ubuntu_

https://askubuntu.com/questions/641405/ricoh-sp111-printer-setup-help

https://blog.droidzone.in/2015/09/23/install-ricoh-sp111-laser-printer-in-ubuntu/

**Brave search:** _ricoh sp111 driver ubuntu github_

https://superuser.com/questions/1563140/printer-printing-only-one-blank-page-ricoh-sp-111

Go to the `$HOME` directory.

```
cd ~/
```

Install necessary dependencies.

```
sudo apt install jbigkit-bin inotify-tools
```

```
sudo apt install --assume-yes imagemagick*
```

Make sure you are in the `$HOME` directory.

```
cd ~/
```

Create a folder 'ricoh'.

```
mkdir ricoh
```

Enter the directory you've created.

```
cd ricoh/
```

Clone a GIT repository that contains the driver files.

```
git clone https://github.com/droidzone/ricoh-sp100.git
```

Enter the folder containing the printer driver files.

```
cd ricoh-sp100/
```

Take a look at what the folder contains.

```
ls
```

Copy the GDI-printer file `pstoricohddst-gdi` to `/usr/lib/cups/filter/`.

```
sudo cp pstoricohddst-gdi /usr/lib/cups/filter/
```

Change the file `pstoricohddst-gdi`'s ownership to 'root'.

```
sudo chown root:root /usr/lib/cups/filter/pstoricohddst-gdi
```

You can also see the location of this file in the root (system) directory from your file manager.

```
/usr/lib/cups/filter/pstoricohddst-gdi
```

Open a web browser in **private**/**incognito** browsing mode and type `http://localhost:631/` in the _address bar_.

```
http://localhost:631/
```

Follow the steps. The steps are self-explanatory.

---

_OpenPrinting CUPS 2.4.1_

1. **Administration** Tab

Connect the Printer to the USB port and power it on.

**Printers**

2. **Add Printer**

![2022-06-05-22-50-34-2022-06-05_21-55](https://user-images.githubusercontent.com/16861933/172064705-c17091f8-8c58-4a6d-ae69-714e96a3d0f7.png)

3. **Local Printers:** RICOH SP 111 DDST (RICOH SP 111 DDST)

Continue

![2022-06-05-22-52-40-2022-06-05_21-56](https://user-images.githubusercontent.com/16861933/172064771-e0ee1b22-b2ee-4971-88bb-233dec28ec57.png)

4. **Location:** _Give your printer a name_ so that people can find it on the network if you ever share your printer over a network.

5. Check the **Share** option if you plan on sharing the printer over a network in the future.

Continue

![2022-06-05-22-56-37-2022-06-05_21-57](https://user-images.githubusercontent.com/16861933/172064780-5f7718a7-a86a-491c-871e-927d264edb7c.png)

6. **Or Provide a PPD File:** **Choose file**

![2022-06-05-22-56-55-2022-06-05_21-58](https://user-images.githubusercontent.com/16861933/172064791-224e31a9-669f-42c5-a9b4-269a69453262.png)

From the file manager, select the file `~/ricoh/ricoh-sp100/RICOH_Aficio_SP_111.ppd`

![2022-06-05-22-57-31-2022-06-05_21-59](https://user-images.githubusercontent.com/16861933/172064800-25bf44af-d4fa-47a4-a588-b6ed2e63a30c.png)

7. **Add Printer**

![2022-06-05-22-57-53-2022-06-05_22-00](https://user-images.githubusercontent.com/16861933/172064812-cdf02a1e-756d-45f5-b9ad-e7df79ecdb87.png)

Set your printer's default options.

![2022-06-05-22-58-52-2022-06-05_22-00_1](https://user-images.githubusercontent.com/16861933/172064824-139ecd7f-e410-482f-924d-e7ca33e06c89.png)

![2022-06-05-22-59-37-2022-06-05_22-01](https://user-images.githubusercontent.com/16861933/172064848-e6d9a6df-0c76-47ef-9014-c1800c29a919.png)

![2022-06-05-22-59-43-2022-06-05_22-01](https://user-images.githubusercontent.com/16861933/172064868-1736dac3-50dc-466b-aff5-919e5c6bf675.png)

At this stage, the printer should show up in **Settings** -> **Printers**.

![2022-06-05-23-00-39-2022-06-05_22-02](https://user-images.githubusercontent.com/16861933/172064901-0cedcfc4-d441-4733-8266-8062b32d824b.png)

Print something to test your printer.

![2022-06-05-23-18-45-IMG_20220605_221233-2_result](https://user-images.githubusercontent.com/16861933/172064916-d95b7d9e-4b61-4855-83f3-292d5d3398df.jpg)
