@echo off

REM Adjust path for the below components. Projects, Libraries and Manager Data folders can be assigned to special locations! Major build number can change after updating BIMcloud! This example here
REM has the installation date 2022-01-10. You can copy this file and adjust the ServerInstallDate below a to create a another backup of another instance.

REM It is very important, that you don't blindli trust this script to work and test it! Look if it really created all the backup files. You also need to check this after every update!

REM First we set the Server installation date. This date defines all the paths Graphisoft uses. In this example, the date is 2022-01-10
set ServerInstallDate=2022-01-10

set ManagerDir=C:\Program Files\GRAPHISOFT\BIMcloud\Manager-%ServerInstallDate%
set ManagerDataDir=C:\Program Files\GRAPHISOFT\BIMcloud\Manager-%ServerInstallDate%\Data
set ServerDir=C:\Program Files\GRAPHISOFT\BIMcloud\Server-%ServerInstallDate%
set ProjectDir=C:\Program Files\GRAPHISOFT\BIMcloud\Server-%ServerInstallDate%\Projects
set LibraryDir=C:\Program Files\GRAPHISOFT\BIMcloud\Server-%ServerInstallDate%\Attachments

REM Caution! The Backup Directory has to already exist as an empty folder. The script will not create it and fail if it does not exists.
set localBkUp=D:\BackupPath\BimserverBackup\Server-%ServerInstallDate%

REM Caution! This services can change with every BimCloud Update! You need to take a look at the Windows Services. Even if you use the this script
REM To backup BimCloud 24 the Service name still changes to the current build Version. In this case v26. With the next update, this could change to v27!
REM I added additonal services to the script to stop all Graphisoft Services

set Manager=PortalServerService-v26.0(Manager-%ServerInstallDate%)
set Server=TeamworkApplicationServerMonitor-v26.0(Server-%ServerInstallDate%)
set ServiceManager=TeamworkServiceProcessManagerAgent-v26.0(Manager-%ServerInstallDate%)
set ServiceServer=TeamworkServiceProcessManagerAgent-v26.0(Manager-%ServerInstallDate%)

REM set delay between Services stopping and starting. Depending on how fast our Server is and how fast it can robocopy the files to the backup destination
set delay=60





REM Editing the script probably not necessary!



REM Checking if BIMcloud Basic or the Backup folder does not exist. Creating sub folders in Backup folder.
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

REM Cleaning the backup folder
rd "%localBkUp%\Server\Config" /S /Q  
rd "%localBkUp%\Server\Mailboxes" /S /Q  
rd "%localBkUp%\Server\Sessions" /S /Q  
rd "%localBkUp%\Server\Projects" /S /Q  
rd "%localBkUp%\Server\Attachments" /S /Q  
rd "%localBkUp%\Manager\Data" /S /Q
rd "%localBkUp%\Manager\Config" /S /Q

REM Stopping Server and Manager and Service Process Manager
sc stop "%Manager%" 
ping localhost -n %delay% >nul

sc stop "%Server%" 
ping localhost -n %delay% >nul

sc stop "%ServiceManager%" 
ping localhost -n %delay% >nul

sc stop "%ServiceServer%" 
ping localhost -n %delay% >nul



REM Copying the Manager's data
robocopy "%ManagerDataDir%" "%localBkUp%\Manager\Data" /E /Z
robocopy "%ManagerDir%\Config" "%localBkUp%\Manager\Config" /E /Z


REM Copying the Server's data
robocopy "%ServerDir%\Config" "%localBkUp%\Server\Config" /E /Z
robocopy "%ServerDir%\Mailboxes" "%localBkUp%\Server\Mailboxes" /E /Z
robocopy "%ServerDir%\Sessions" "%localBkUp%\Server\Sessions" /E /Z
robocopy "%ProjectDir%" "%localBkUp%\Server\Projects" /E /Z
robocopy "%LibraryDir%" "%localBkUp%\Server\Attachments" /E /Z


REM If you wanna reboot the server instead of starting the services, delete the "REM" in the next two lines. The services start on its own on boot.
REM shutdown /r /t 10
REM :done


REM Restarting Server service with 60 seconds delay
sc start "%Manager%"
ping localhost -n %delay% >nul

sc start "%Server%"
ping localhost -n %delay% >nul

sc start "%ServiceManager%"
ping localhost -n %delay% >nul

sc start "%ServiceServer%"
ping localhost -n %delay% >nul

:done
