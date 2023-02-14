# BIMCloudBasicBackupScript

Unfortunately BIMCloud Basic has no backup option included.

That is why I wrote my own script, based on the BimCloud v24 backup script from Graphisoft:
http://dl.graphisoft.com/ftp/techsupport/documentation/BIMcloud_Backup_Guide/v24PcServerAndManagerBk...
I was unable to find a newer official template. Please let me know if you spot a new one.
The script was tested (14.02.2023) to work with with BIMCloud 2022.1.

The script is just a single backup.bat batch file. 

Please carefully read the comments in the script. Every line that starts with "REM" is a comment and not code. Adjust the paths and services accordingly. 
Be carefull to read the fine print during the BIMCloud installation, if you have BIMCloud basic, do NOT set a Backup destination path during the installation!
Like the original script vom ArchiCAD, this script only creates a single backup state. If you want multiple backup days/states, you should consider some kind of file versioning or snapshots of your backup destination. 
Remember to always test the script and make sure it really works. I don't take any responsibility. If you need technical support or have questions you find contact information on www.salzmann.solutions

Requirements that are out of the scope of this repository:

- Windows task scheduler to automatically start this script automatically 
- File versioning or snapshots to have multiple backup states
