# Factorio Init Script
A simple factorio init script for linux

# Install
- Create a directory where you want to store this script along with configuration. (either copy-paste the files or clone from github):

 ```bash
 $ cd '/opt'
 $ git clone https://github.com/Bisa/factorio-init.git
 ```
- Rename config.example to config and modify the values within according to your setup.
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
