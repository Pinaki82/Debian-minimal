@ECHO OFF
rem tesseract.exe doesn't work without an active internet connection.
rem Make sure you're connected to the internet before running this
rem batch script.
@ECHO ON

for %%A in ("*.*") DO "C:\FreeOCR\tesseract.exe" "%%A" "%%A.TXT"
cmd

