@ECHO OFF
REM Automated update for malicious hostnames curated by users from across the world.
@ECHO ON

@ECHO OFF
REM Download the lists of hostnames in multiple files, then merge the downloaded file into one large text blob
@ECHO ON
curl "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts" --output hosts00001.txt

@ECHO OFF
REM curl "https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts" --output hosts00002.txt
REM curl "https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt" --output hosts00003.txt
REM curl "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts" --output hosts00004.txt
REM curl "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Dead/hosts" --output hosts00005.txt
REM curl "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts" --output hosts00006.txt
REM curl "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts" --output hosts00007.txt
REM curl "https://raw.githubusercontent.com/AdguardTeam/cname-trackers/master/combined_disguised_trackers_justdomains.txt" --output hosts00008.txt
REM curl "https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts" --output hosts00009.txt
REM curl "https://raw.githubusercontent.com/bigdargon/hostsVN/master/option/hosts-VN" --output hosts00010.txt
REM curl "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt" --output hosts00011.txt
REM curl "https://raw.githubusercontent.com/MetaMask/eth-phishing-detect/master/src/hosts.txt" --output hosts00012.txt
REM curl "https://raw.githubusercontent.com/jamiemansfield/minecraft-hosts/master/lists/tracking.txt" --output hosts00013.txt
REM curl "https://winhelp2002.mvps.org/hosts.txt" --output hosts00014.txt
REM curl "https://raw.githubusercontent.com/shreyasminocha/shady-hosts/main/hosts" --output hosts00015.txt
REM curl "https://someonewhocares.org/hosts/zero/hosts" --output hosts00016.txt
REM curl "https://raw.githubusercontent.com/tiuxo/hosts/master/ads" --output hosts00017.txt
REM curl "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts" --output hosts00018.txt
REM curl "https://urlhaus.abuse.ch/downloads/hostfile/" --output hosts00019.txt
REM curl "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&mimetype=plaintext&useip=0.0.0.0" --output hosts00020.txt

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

@ECHO OFF
REM del hosts00002.txt
REM del hosts00003.txt
REM del hosts00004.txt
REM del hosts00005.txt
REM del hosts00006.txt
REM del hosts00007.txt
REM del hosts00008.txt
REM del hosts00009.txt
REM del hosts00010.txt
REM del hosts00011.txt
REM del hosts00012.txt
REM del hosts00013.txt
REM del hosts00014.txt
REM del hosts00015.txt
REM del hosts00016.txt
REM del hosts00017.txt
REM del hosts00018.txt
REM del hosts00019.txt
REM del hosts00020.txt
@ECHO ON

cmd
