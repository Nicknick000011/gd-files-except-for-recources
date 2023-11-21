@echo off

:: Change directory
cd %~dp0

:: Check that the directory is correct
if not exist "GeometryDash.exe" (
    echo You need to run this script in the location of GeometryDash.exe.
    echo You can find GD through Steam ^> Right-Click GD ^> Properties ^> Local Files ^> Browse local files
    echo Move this file ^(BetterEdit_installer.bat^) there, and run it again to install BetterEdit.
    echo.
    pause
    exit
)

:: Check for Geode
if exist "geode.dll" (
    echo Please join the BetterEdit 5 Discord server to download the BetterEdit v5 Alpha ^(the only compatible version with Geode^). https://discord.gg/UGHDfzQtpz
    echo Be aware that you can not run any other standalone mods or modloaders alongside Geode.
    echo.
    pause
    exit
)

:: Check for MHv7
if exist "hackpro.dll" (
    echo MegaHack detected, installing for it
    set installdir="extensions"
) else (
    :: Check for GDHM
    if exist "ToastedMarshmellow.dll" (
        echo GDHM detected, installing for it
        set installdir=".GDHM\dll"
    ) else (
        :: Check for Quickldr, install if not found
        if exist "quickldr.dll" (
            echo QuickLdr detected, installing for it
            set installdir="quickldr"
        ) else (
            echo No modloader detected, installing QuickLdr

            :: Download QuickLdr
            echo Downloading QuickLdr
            curl https://cdn.discordapp.com/attachments/837026406282035300/859008315413626920/quickldr-v1.1.zip -o quickldr.zip -s
            curl https://cdn.discordapp.com/attachments/837026406282035300/961654283399483442/XInput9_1_0.dll -o XInput9_1_0.dll -s
            
            :: Extract quickldr
            echo Extracing QuickLdr
            mkdir quickldr
            tar -xf quickldr.zip -C quickldr

            :: Delete the archive and libcurl
            del quickldr.zip
            del quickldr\libcurl.dll

            :: Move to the gd folder
            echo Installing QuickLdr
            move /y quickldr\quickldr.dll quickldr.dll
            
            :: Set installdir variable
            set installdir="quickldr"
        )
    )
)

:: Install Minhook
if not exist "minhook.x32.dll" (
    echo Downloading Minhook
    curl https://cdn.discordapp.com/attachments/837026406282035300/856484662028795924/minhook.x32.dll -o minhook.x32.dll -s

    rem Since CWD is target dir, minhook will be at the correct place
)

:: Make target directory
if not exist "%installdir%\" (
    mkdir "%installdir%"
)

:: Make settings.txt
if exist "quickldr.dll" (
    echo BetterEdit-v4.0.5.dll >> "quickldr\settings.txt"
)

:: Make directory
mkdir betteredit_temp

:: Download files
echo Downloading BetterEdit
curl https://cdn.discordapp.com/attachments/879292748224688179/947496970606510080/BetterEdit-v4.0.5.zip -o BetterEdit-v4.0.5.zip -s

:: Extract Files
echo Extracting BetterEdit
tar -xf BetterEdit-v4.0.5.zip -C betteredit_temp

:: Delete unnecessary files
del betteredit_temp\BetterEdit-v4.0.5-min.dll
del betteredit_temp\installation.txt
del betteredit_temp\LICENSE
del betteredit_temp\minhook.x32.dll

:: Move to the quickldr folder
move /y betteredit_temp\BetterEdit-v4.0.5.dll "%installdir%"

:: Move images to resources
move /y betteredit_temp\* Resources\

:: Delete temp stuff
echo Cleaning up
rmdir betteredit_temp
del BetterEdit-v4.0.5.zip

:: Let the user know it succeeded
echo Installation succesful!
echo.
pause
