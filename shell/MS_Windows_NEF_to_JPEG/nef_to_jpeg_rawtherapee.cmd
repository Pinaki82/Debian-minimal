@echo off
setlocal EnableDelayedExpansion

REM  — Written by ChatGPT on 2025.08.02

REM ========================== COMMENT BLOCK ==========================
REM
REM Minimal‑purpose batch script: converts only *.NEF files into JPEGs,
REM stores them in a “converted” subfolder and reports how long it took.
REM
REM Key Behaviour:
REM   1. Expects rawtherapee‑cli.exe in PATH (or edit CLI= manually)
REM   2. Normalises "%TIME%" with → `set "startTime=%time: =0%"` (avoids leading-space hour)
REM   3. Parses time into hours, minutes, seconds, centiseconds (`tokens=1‑4 delims=:. ,`)
REM   4. Computes centisecond counts and subtracts them to get **elapsed time**
REM      — handles **midnight rollover** via a conditional check (`IF "%endTime%" GTR "%startTime%"` ... else add 24 h) :contentReference[oaicite:1]{index=1}
REM   5. Formats the result into **HH:MM:SS,cc** with zero-padding (via `set /A` math)
REM   6. Creates a "converted" directory if it doesn’t exist
REM   7. Processes only files ending in `*.NEF` → camera JPEGs (`*.JPG`) are *skipped*
REM   8. Converts via `rawtherapee‑cli` using:
REM         - `-d`   → default engine profile (as set in Preferences) :contentReference[oaicite:2]{index=2}
REM         - `-j100` → max JPEG quality, `-js3` → full chroma (4:4:4)
REM         - `-Y`   → overwrite existing output
REM         - `-o converted` → directs output into the “converted” subfolder
REM   9. After looping, echoes:
REM         Start time, End time, and **Elapsed duration**
REM   10. Uses `PAUSE` so the window remains open after processing completes
REM
REM Customisation Tips:
REM   • Adjust QUALITY-Q / SUBSAMPLE‑js values to trade quality ↔ file size
REM   • To use a custom path for rawtherapee‑cli.exe, edit the CLI variable
REM   • For deeper recursion (e.g. nested session folders), adapt the FOR loop logic
REM
REM Under the hood: Time‑difference logic based on a centisecond‑counting script
REM originally posted by **Aacini** on StackOverflow, with support for rollover at midnight :contentReference[oaicite:3]{index=3}
REM
REM ======================== END COMMENT BLOCK =========================


REM — Change only if rawtherapee‑cli.exe isn't already in PATH
set "CLI=rawtherapee-cli.exe"
where "%CLI%" >nul 2>&1 || (
  echo ERROR: "%CLI%" not found in PATH.^
         Please install it or set CLI variable. 
  pause & exit /b 1
)

REM Record start time (normalized to avoid leading-space hour)
set "startTime=%time: =0%"

REM Create "converted" subfolder if it doesn't exist
if not exist "converted" mkdir "converted"

REM Loop over only NEF files (camera JPGs are skipped)
for %%F in ("*.NEF") do (
  echo Converting %%~nxF → converted\%%~nF.jpg
  "%CLI%" -d -j100 -js3 -Y -o "converted" -c "%%F"
)

REM Record finish time
set "endTime=%time: =0%"

REM Compute elapsed time (HH:MM:SS,CC). Courtesy: Aacini’s algorithm from Stack Overflow :contentReference[oaicite:1]{index=1}
for /F "tokens=1-4 delims=:.," %%a in ("%startTime%") do (
  set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
for /F "tokens=1-4 delims=:.," %%a in ("%endTime%") do (
  IF "%endTime%" GTR "%startTime%" (
    set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
  ) ELSE (
    set /A "end=((((%%a+24)*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
  )
)
set /A "elapsed=end-start"

set /A hh=elapsed/(60*60*100)^
  , rest=elapsed%%(60*60*100)^
  , mm=rest/(60*100)^
  , rest%%=60*100^
  , ss=rest/100^
  , cc=rest%%100
if %hh% lss 10 set hh=0%hh%
if %mm% lss 10 set mm=0%mm%
if %ss% lss 10 set ss=0%ss%
if %cc% lss 10 set cc=0%cc%
set "DURATION=%hh%:%mm%:%ss%,%cc%"

echo.
echo ➜ Conversion done. 
echo Start:    %startTime%
echo Finish:   %endTime%
echo Elapsed:  %DURATION%
pause
