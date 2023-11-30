@echo off

REM Version 1.6

REM Adjust path for the below components. Projects, Libraries, and Manager Data folders all have different locations! The services name can change after updating BIMcloud! That is why
REM you have to check this script after every Update!
REM It is very important, that you don't blindly trust this script to work and test it! Check if it really created a backup of all files.
REM Per default, this script only creates one backup state. If you wanna save multiple days or states, you should consider using some kind of OS file versioning or snapshots.
REM If you need technical support or have questions you find contact information on www.salzmann.solutions

REM This example here has the installation date 2023-11-30. You can dublicate this file to backup multiple instances of BIMCloudBasic. Just remember to set all paths accordingly.

REM First we set the Server installation date. This variable is used to set all Graphisoft paths accordingly. In this example, the date is 2023-11-30. Adjust it according to your installation. 
set ServerInstallDate=2023-11-30

REM Next we set the backup path.
REM Caution! The Backup Directory has to already exist as an empty folder. The script will not create it and fail if it does not already exists.
set localBkUp=D:\BimBackup\Server-%ServerInstallDate%

REM Next we set names of the services.
REM Open "services" and go to the "Graphisoft" services. You can double click on them to open them and look up the name under "Service name". 
REM The BIMCloud naming is not the same as the ArchiCAD naming! By November 2023 the current version is called BimCloud 2023.3 and the services end with V28. 
REM Caution! These services can change with every BimCloud Update! 
set service1=PortalServerService-v28.0(Manager-%ServerInstallDate%)
set service2=TeamworkApplicationServerMonitor-v28.0(Server-%ServerInstallDate%)

REM set a delay for starting and stopping services, depending on how fast our Server can star and stop services.
set delay=20

REM Editing the script below should not be necessary

REM Because we previously set the install date as a %ServerInstallDate% variable, we pupulate the other paths automatically.
set ManagerDir=C:\Program Files\GRAPHISOFT\BIMcloud\Manager-%ServerInstallDate%
set ManagerDataDir=C:\Program Files\GRAPHISOFT\BIMcloud\Manager-%ServerInstallDate%\Data
set ServerDir=C:\Program Files\GRAPHISOFT\BIMcloud\Server-%ServerInstallDate%
set ProjectDir=C:\Program Files\GRAPHISOFT\BIMcloud\Server-%ServerInstallDate%\Projects
set LibraryDir=C:\Program Files\GRAPHISOFT\BIMcloud\Server-%ServerInstallDate%\Attachments

REM Checking if BIMcloud Basic or the Backup folder does not exist. You must create them beforehand!
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

REM Stopping services
sc stop "%service1%" 
ping localhost -n %delay%

sc stop "%service2%" 
ping localhost -n %delay%

REM The original Backup routine from Graphisoft deleted all folders and then copied over all files. 
REM In my opinion, this is unnecessary writes. Instead of deleting everything and rewriting it afterward, we can mirror the source to our backup destination. 
REM with the mirror option, only changed files need to be rewritten. Deleted files in the source also get deleted in the backup destination. 

REM Copying the Managers data
robocopy "%ManagerDataDir%" "%localBkUp%\Manager\Data" /MIR /R:10 /W:3
robocopy "%ManagerDir%\Config" "%localBkUp%\Manager\Config" /MIR /R:10 /W:3

REM Copying the Servers data
robocopy "%ServerDir%\Config" "%localBkUp%\Server\Config" /MIR /R:10 /W:3
robocopy "%ServerDir%\Mailboxes" "%localBkUp%\Server\Mailboxes" /MIR /R:10 /W:3
robocopy "%ServerDir%\Sessions" "%localBkUp%\Server\Sessions" /MIR /R:10 /W:3
robocopy "%ProjectDir%" "%localBkUp%\Server\Projects" /MIR /R:10 /W:3
robocopy "%LibraryDir%" "%localBkUp%\Server\Attachments" /MIR /R:10 /W:3

REM If you wanna reboot the server instead of starting the services, delete the "REM" in the next two lines. The services start on their own on boot.
REM shutdown /r /t 10
REM :done

REM Restarting Server services with delay
sc start "%service1%"
ping localhost -n %delay%

sc start "%service2%"
ping localhost -n %delay%

:done
