# Factorio Init Script
A factorio init script for linux

# Dependencies
 Among others:
 - cURL

# Debugging
 If you find yourself wondering why stuff is not working the way you expect:
 - Check the logs, I suggest you `tail -f /opt/factorio/factorio-current.log` in a separate session
 - Enable debugging in the config and/or:
 - Try running the same commands as the factorio user (`/opt/factorio-init/factorio invocation` will tell you what the factorio user tries to run at start)

 ```bash
 $ /opt/factorio-init/factorio invocation
 #  Run this as the factorio user, example:
 $ sudo -u factorio 'whatever invocation gave you'
 # You should see some output in your terminal here, hopefully giving
 # you a hint of what is going wrong
 ```

# Install
- Create a directory where you want to store this script along with configuration. (either copy-paste the files or clone from github):

 ```bash
 $ cd '/opt'
 $ git clone https://github.com/Bisa/factorio-init.git
 ```
- Rename config.example to config and modify the values within according to your setup.

## Notes for users with an OS that has a older glibc version:

- The config has options for declaring a alternate glibc root. The user millisa over on the factorio forums has created a wonderful guide to follow on creating this alternate glibc root ( side by side ) here:
https://forums.factorio.com/viewtopic.php?t=54654#p324493

## First-run
- If you don't have Factorio installed already, use the `install` command:

 ```bash
 $ /opt/factorio-init/factorio install  # see help for options
 ```

- The installation routine creates Factorio's `config.ini` automatically.

- If you previously ran Factorio without this script, the existing `config.ini` should work fine.

## Autocompletion
- Copy/Symlink or source the bash_autocompletion file

 ```bash
 $ ln -s /opt/factorio-init/bash_autocomplete /etc/bash_completion.d/factorio
 # OR:
 $ echo "source /opt/factorio-init/bash_autocomplete" >> ~/.bashrc
 # restart your shell to verify that it worked
 ```

## Systemd
- Copy the example service, adjust & reload

 ```bash
 $ cp /opt/factorio-init/factorio.service.example /etc/systemd/system/factorio.service
 # Edit the service file to suit your environment then reload systemd
 $ systemctl daemon-reload
 ```

- Verify that the server starts

 ```bash
 $ systemctl start factorio
 $ systemctl status -l factorio
 # Remember to enable the service at startup if you want that:
 $ systemctl enable factorio
 ```

## SysvInit
- Symlink the init script:

 ```bash
 $ ln -s /opt/factorio-init/factorio /etc/init.d/factorio
 # Make the script executable:
 $ chmod +x /opt/factorio-init/factorio
 # Try it out:
 $ service factorio help
 # Do not forget to enable the service at boot if you want that.
 ```

# Thank You
- To all who find this script useful in one way or the other
- A big thank you to [Wube](https://www.factorio.com/team) for making [Factorio](https://www.factorio.com/)
- A special thanks to NoPantsMcDance, Oxyd, HanziQ, TheFactorioCube and all other frequent users of the [#factorio](irc://irc.esper.net/#factorio) channel @ esper.net
- Thank you to Salzig for pointing me in the right direction when it comes to input redirection
- At last, but not least; Thank you to all [contributors](https://github.com/Bisa/factorio-init/graphs/contributors) and users posting [issues](https://github.com/Bisa/factorio-init/issues) in my [github](https://github.com/Bisa/factorio-init/) project or on the [factorio forums](https://forums.factorio.com/viewtopic.php?f=133&t=13874)

You are all a great source of motivation, thank you.

# License
This code is realeased with the MIT license, see the LICENSE file.
