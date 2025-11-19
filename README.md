# BIMCloudBasicBackupScript
**The script was tested on the 19.11.2025 to work with BIMCloud 2025.3.**  

Unfortunately BIMCloud Basic has no backup option included.  

That is why I wrote my own script, based on the BimCloud v24 backup script from Graphisoft.    (http://dl.graphisoft.com/ftp/techsupport/documentation/BIMcloud_Backup_Guide/v24PcServerAndManagerBkUp.zip)  
Mine is IMHO be a little bit more polished and smarter. 

## What it does
The script is just a single backup.bat batch file.  
What is basically does is shutting down the manager and server, then robocopy all files to the backup folder and then start your services again.

## How to use it
This has nothing to do with my script, but if you are using BIMCloud basic, do NOT set a Backup destination path during the installation of BimCloud! 

Please carefully read the comments in the script. Every line that starts with "REM" is a comment and not code.  
Adjust the paths and services accordingly.  

To automatically start this script with Windows task scheduler, you checkout BIMBackup.xml from this repository. It should offer you a good template.  

Like the original script vom ArchiCAD, this script only creates a single backup state.   
If you want multiple backup days/states, you should consider some kind of file versioning or snapshots of your backup destination.   
Remember to always test the script and make sure it really works!  
I don't take any responsibility. If you need technical support or have questions, please open an github issue or contact mail@salzmann.solutions  
