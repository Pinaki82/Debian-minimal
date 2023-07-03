@ECHO OFF

REM   DocTo
REM   https://github.com/tobya/DocTo

REM   Simple utility for converting a Microsoft Word Document '.doc' and Microsoft
REM   Excel '.xls' files to any other supported format such as .txt .csv .rtf .pdf.

REM   Batch Conversion:
REM   docto -f "C:\Dir with Spaces\FilesToConvert\" -O "C:\DirToOutput" -T wdFormatPDF  -OX .pdf

REM   Formats:
REM   wdFormatPDF
REM   xlCSV
REM   wdFormatText

REM   Help:
REM   docto.exe -h

@ECHO ON

docto -f "S:\Word Docs Pen Drv\" -O "S:\DCSPEN2TXT" -T wdFormatText  -OX .txt
cmd
