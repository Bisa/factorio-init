# Factorio Init Script
A simple factorio init script for linux

# Debugging
 If you find yourself wondering why stuff is not working the way you expect:
 - Enable debugging in the config
 and/or
 - Try running the same commands as the factorio user

 ```bash
 $ cd '/opt/factorio-init'
 $ source ./config  # Grab the config variables
 $ echo $INVOCATION # Does this look correct to you?
 $ $INVOCATION #Start the server, watch the log output for any Errors
 ```

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

 # License
 This code is realeased with the MIT license, see the LICENSE file.
