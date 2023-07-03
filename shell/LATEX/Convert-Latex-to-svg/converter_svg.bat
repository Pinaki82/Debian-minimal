@echo off
REM path=C:\Program Files\MiKTeX 2.9\miktex\bin\x64;C:\Program Files (x86)\gs\gs9.05\bin;%path%;
path=%APPDATA%\Local\Programs\MiKTeX\miktex\bin\x64\;C:\Program Files\gs\gs9.53.3\bin;%path%;
@echo on

latex int01.tex
dvisvgm --no-fonts int01.dvi int01.svg

del *.aux *.dvi *.log
cmd
