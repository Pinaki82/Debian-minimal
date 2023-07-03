SET PATH="C:\Program Files (x86)\exiftool-10.31";%PATH%;
exiftool -k -a -u -g1 -w txt  -filename -aperture -exposuretime -ISO -focallength -FocalLengthIn35mmFormat -CreateDate -exiftool -AFAreaMode -AFAperture -CircleOfConfusion -Flash -FlashType -FocusDistance -FocusMode -FOV -LensID -ProfileDescription -Software -ExifToolVersion -r *
CMD
