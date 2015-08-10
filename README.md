# Factorio Init Script
A simple factorio init script for linux

# Install
- Create a directory where you want to store this script along with configuration. (either copy-paste the files or clone from github):

 ```bash
 $ cd '/opt'
 $ git clone https://github.com/Bisa/factorio-init.git
 ```
- Rename config.example to config and modify the values within according to your setup.

## SysvInit
- Symlink the init script:

 ```bash
 $ ln -s /opt/factorio-init/factorio /etc/init.d/factorio
 ```
- Make the script executable:

 ```bash
 $ chmod +x /opt/factorio-init/factorio
 ```
- Try it out!

 ```bash
 $ service factorio help
 ```

## Systemd (includes crash detection & restart)
- Symlink the systemd unit file and configuration (have a look at the files in case you need to modify them for your environment)
 
 ```bash
 $ ln -s /opt/factorio-init/factorio.service /etc/systemd/system/
 $ ln -s /opt/factorio-init/config /etc/default/factorio
 ```
- Symlink the init-script to allow controlling the server from the commandline (optionally, change the path to the script in the unit file)
 
 ```bash
 $ ln -s /opt/factorio-init/factorio /usr/local/bin/
 ```
- Reload to allow systemd to pick up your new unit and start the service
 
 ```bash
 $ systemctl daemon-reload
 $ systemctl factorio start
 ```
