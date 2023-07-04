@ECHO OFF
REM Automated update for malicious hostnames curated by users from across the world.

REM Download the lists of hostnames in multiple files, then merge the downloaded file into one large text blob

REM Block everything without social media sites.
@ECHO ON

curl "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts" --output hosts00001.txt

@ECHO OFF
REM concatenate
REM concatenate multiple text files
REM https://search.brave.com/search?q=combine+all+text+files+with+one+command&source=desktop
REM copy /b *.txt newfile.txt
@ECHO ON

copy /b *.txt totalhosts.txt

@ECHO OFF
REM Delete the downloaded files once the resulting file has been created
@ECHO ON

del hosts00001.txt

cmd
