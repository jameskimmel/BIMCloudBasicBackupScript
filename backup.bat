@echo off

REM Version 1.3
REM Adjust path for the below components. Projects, Libraries, and Manager Data folders can be assigned to special locations! The Major build number can change after updating BIMcloud! This example here
REM has the installation date 2022-01-10. You can copy this file and adjust the ServerInstallDate below to create another backup of another instance.

REM It is very important, that you don't blindly trust this script to work and test it! Look if it really created all the backup files. You also need to check this after every update!
REM Per default, this script only creates one backup state. If you wanna save multiple days or states, you should consider using some kind of file versioning or snapshots.
REM If you need technical support or have questions you find contact information on www.salzmann.solutions

REM First we set the Server installation date. This date defines all the paths Graphisoft uses. In this example, the date is 2022-01-10
set ServerInstallDate=2022-01-10

set ManagerDir=C:\Program Files\GRAPHISOFT\BIMcloud\Manager-%ServerInstallDate%
set ManagerDataDir=C:\Program Files\GRAPHISOFT\BIMcloud\Manager-%ServerInstallDate%\Data
set ServerDir=C:\Program Files\GRAPHISOFT\BIMcloud\Server-%ServerInstallDate%
set ProjectDir=C:\Program Files\GRAPHISOFT\BIMcloud\Server-%ServerInstallDate%\Projects
set LibraryDir=C:\Program Files\GRAPHISOFT\BIMcloud\Server-%ServerInstallDate%\Attachments

REM Caution! The Backup Directory has to already exist as an empty folder. The script will not create it and fail if it does not exist.
set localBkUp=D:\BackupPath\BimserverBackup\Server-%ServerInstallDate%

REM Caution! These services can change with every BimCloud Update! You have to look it up in the Windows "services" application. Even if you use this script
REM To backup BimCloud 24, BIMCloud could be on a higher Version and the service name reflects that Version. By January 2022 the current version is v26. With the next update, this could change to v27!
REM I added additional services to the script to stop all Graphisoft Services

set Manager=PortalServerService-v26.0(Manager-%ServerInstallDate%)
set Server=TeamworkApplicationServerMonitor-v26.0(Server-%ServerInstallDate%)


REM set the delay between Services stopping and starting. Depending on how fast our Server is and how fast it can robocopy the files to the backup destination
set delay=60

REM Editing the script below should not be necessary

REM Checking if BIMcloud Basic or the Backup folder does not exist. Creating subfolders in the Backup folder.
if not exist "%ManagerDir%" echo Missing installation directory "%ManagerDir%"
if not exist "%ManagerDataDir%" echo Missing installation directory "%ManagerDataDir%"
if not exist "%ServerDir%" echo Missing installation directory "%ServerDir%"
if not exist "%ProjectDir%" echo Missing installation directory "%ProjectDir%"
if not exist "%LibraryDir%" echo Missing installation directory "%LibraryDir%"
if not exist "%localBkup%" echo Missing Backup folder "%localBkup%"

if not exist "%ManagerDir%" goto done
if not exist "%ManagerDataDir%" goto done
if not exist "%ServerDir%" goto done
if not exist "%ProjectDir%" goto done
if not exist "%LibraryDir%" goto done
if not exist "%localBkup%" goto done

if not exist "%localBkUp%\Server" md "%localBkUp%\Server"
if not exist "%localBkUp%\Manager" md "%localBkUp%\Manager"

if not exist "%localBkUp%\Server" goto done
if not exist "%localBkUp%\Manager" goto done

REM Stopping Server and Manager and Service Process Manager
sc stop "%Manager%" 
ping localhost -n %delay% >nul

sc stop "%Server%" 
ping localhost -n %delay% >nul

REM The original Backup routine from Graphisoft deleted all folders and then copied over all files. 
REM In my opinion, this is unnecessary writes. Instead of deleting everything and rewriting it afterward, we can mirror the source to our backup destination. 
REM with the mirror option, only changed files need to be rewritten. Deleted files in the source also get deleted in the backup destination. 

REM Copying the Manager's data
robocopy "%ManagerDataDir%" "%localBkUp%\Manager\Data" /MIR /R:10 /W:3
robocopy "%ManagerDir%\Config" "%localBkUp%\Manager\Config" /MIR /R:10 /W:3

REM Copying the Server's data
robocopy "%ServerDir%\Config" "%localBkUp%\Server\Config" /MIR /R:10 /W:3
robocopy "%ServerDir%\Mailboxes" "%localBkUp%\Server\Mailboxes" /MIR /R:10 /W:3
robocopy "%ServerDir%\Sessions" "%localBkUp%\Server\Sessions" /MIR /R:10 /W:3
robocopy "%ProjectDir%" "%localBkUp%\Server\Projects" /MIR /R:10 /W:3
robocopy "%LibraryDir%" "%localBkUp%\Server\Attachments" /MIR /R:10 /W:3



REM If you wanna reboot the server instead of starting the services, delete the "REM" in the next two lines. The services start on their own on boot.
REM shutdown /r /t 10
REM :done


REM Restarting Server service with 60 seconds delay
sc start "%Manager%"
ping localhost -n %delay% >nul

sc start "%Server%"
ping localhost -n %delay% >nul


:done
