@ECHO OFF
REM # Encrypt Folders using "AES Crypt" (https://www.aescrypt.com/).
REM #
REM # https://alternativeto.net/software/folder-lock/?license=opensource
REM # https://www.aescrypt.com/
REM # choco install -y aescrypt
REM #
REM # Add "C:\Program Files\AESCrypt" to the Environment Variable after installing the program.
REM #
REM # NOTE: Use VeraCrypt to encrypt large volumes.
REM #
REM # "AES Crypt" requires Java Runtime Environment.
REM # Chocolatey: choco install -y javaruntime
REM # Or, get it here: https://www.java.com/en/download/windows_manual.jsp
REM #
REM # WINDOWS + r -> systempropertiesadvanced ->
REM # -> Environment Variables ->
REM # -> System Variables -> Path -> Edit -> New
REM # Add
REM # C:\Program Files\AESCrypt
REM #
REM # Alternative Method:
REM #
REM # Open CMD in Admin mode:
REM # 1. Windows Key + r (Run Prompt)
REM # 2. Type cmd
REM # 3. CTRL+SHIFT+ENTER
REM # rundll32.exe sysdm.cpl,EditEnvironmentVariables
REM # Or,
REM # rundll32.exe shell32.dll,Control_RunDLL sysdm.cpl,,3
REM #
REM # https://appuals.com/how-to-edit-environment-variables-in-windows-10/
REM # https://www.autohotkey.com/board/topic/68086-open-the-environment-variable-editing-window/
REM #
REM # Environment Variables ->
REM # -> System Variables -> Path -> Edit -> New
REM # Add
REM # C:\Program Files\AESCrypt
REM #
REM # Install 7-Zip if you want to use 7-Zip instead of MS Windows 10's default tar (not needed here).
REM # choco install -y 7zip
REM # Add 7-Zip (C:\Program Files\7-Zip) to the Environment Variable.
REM #
@ECHO ON

@ECHO OFF
REM # Referenced:
REM # https://www.tutorialspoint.com/batch_script/batch_script_functions.htm
REM # https://www.tutorialspoint.com/batch_script/batch_script_choice.htm#
REM # https://www.computerhope.com/issues/ch001674.htm
@ECHO ON

@ECHO OFF
cls
:start
ECHO.
ECHO 1. Encrypt Folder
ECHO 2. Decrypt Folder
ECHO 3. Cancel the operation
echo ---------------------------------------------------------------------------------------
echo NOTE: Folder/archive names must not contain spaces or special characters.
echo Press TAB to autocomplete.
echo ---------------------------------------------------------------------------------------
set choice=
set /p choice=Type the number corresponding to the option:
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto EncryptFolder
if '%choice%'=='2' goto DecryptFolder
if '%choice%'=='3' goto end
ECHO "%choice%" is not valid, try again!
ECHO.
goto start


:EncryptFolder
set /p foldername="Type the folder name: "
echo foldername: %foldername%
set foldername_w_tar_extension=%foldername%.tar
echo foldername_w_tar_extension: %foldername_w_tar_extension%
@ECHO OFF
REM # set foldername_w_7z_extension=%foldername%.7z
REM # echo foldername_w_7z_extension: %foldername_w_7z_extension%
REM # https://7ziphelp.com/7zip-command-line
REM # 7z a -t7z -mx1 %foldername_w_7z_extension% %foldername%
REM # Windows 10 comes with native tar support.
REM # https://superuser.com/questions/339931/how-do-i-use-7-zip-cli-for-windows-to-create-tar-gz-archives
@ECHO ON
tar -cvf %foldername_w_tar_extension% %foldername%
aescrypt -e %foldername_w_tar_extension%

@ECHO OFF

@ECHO ON
EXIT /B 0
goto end

:DecryptFolder
set /p filename="Type the file name to decrypt (file.tar.aes): "
echo filename: %filename%
aescrypt -d %filename%
@setlocal enableextensions enabledelayedexpansion
@ECHO OFF
REM # https://stackoverflow.com/questions/3732947/batch-to-remove-character-from-a-string
set variable=%filename%
echo !variable!
if "x!variable:~-8!"=="x.tar.aes" (
    set variable=!variable:~0,-8!
)
REM # echo !variable!
set variable2=%variable%.tar
REM # echo %variable2%
@ECHO ON
tar -xvf %variable2%

PAUSE
endlocal
EXIT /B 0
goto end

:end
PAUSE
EXIT /B 0
