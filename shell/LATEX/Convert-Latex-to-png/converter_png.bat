@echo off
REM path=C:\Program Files\MiKTeX 2.9\miktex\bin\x64;C:\Program Files (x86)\gs\gs9.05\bin;%path%;
path=%APPDATA%\Local\Programs\MiKTeX\miktex\bin\x64\;C:\Program Files\gs\gs9.53.3\bin;%path%;
@echo on

latex int01.tex
latex eq001.tex

dvipng -T tight -D 300 --bdpi 300 -z 9 -bg Transparent -quality 90 -o int01.png int01.dvi
dvipng -T tight -D 300 --bdpi 300 -z 9 -bg Transparent -quality 90 -o eq001.png eq001.dvi

del *.aux *.dvi *.log
cmd
