# Factorio Init

A factorio init script in bash

## Debugging

If you find yourself wondering why stuff is not working the way you expect:

- Check the logs, I suggest you `tail -f /opt/factorio/factorio-current.log` in a separate session
- Enable debugging in the config and/or:
- Try running the same commands as the factorio user (`/opt/factorio-init/factorio invocation` will tell you what the factorio user tries to run at start)

 ```bash
 /opt/factorio-init/factorio invocation
 #  Run this as the factorio user, example:
 sudo -u factorio 'whatever invocation gave you'
 # You should see some output in your terminal here, hopefully giving
 # you a hint of what is going wrong
 ```

## Install

- Create a directory where you want to store this script along with configuration. (either copy-paste the files or clone from github):

 ```bash
 cd '/opt'
 git clone https://github.com/Bisa/factorio-init.git
 ```

- Rename config.example to config and modify the values within according to your setup.

### Notes for users with an OS that has a older glibc version

The config has options for declaring an alternate glibc root. The user millisa over on the factorio forums has created a wonderful [guide](https://forums.factorio.com/viewtopic.php?t=54654#p324493) to follow on creating this alternate glibc root (side by side).

### First-run

- If you don't have Factorio installed already, use the `install` command:

 ```bash
 /opt/factorio-init/factorio install  # see help for options
 ```

- The installation routine creates Factorio's `config.ini` automatically.

- If you previously ran Factorio without this script, the existing `config.ini` should work fine.

### Autocompletion

- Copy/symlink or source the bash_autocompletion file
- Ensure the factorio script is in your path

```bash
# either symlink:
ln -s /opt/factorio-init/bash_autocomplete /etc/bash_completion.d/factorio
# or source:
echo "source /opt/factorio-init/bash_autocomplete" >> ~/.bashrc

# then ensure factorio-init is added to your PATH, ie by:
ln -s /opt/factorio-init/factorio /usr/local/bin/factorio

# restart your shell to verify that it worked
```

### Systemd

- Copy the example service, adjust & reload

```bash
cp /opt/factorio-init/factorio.service.example /etc/systemd/system/factorio.service
# Edit the service file to suit your environment then reload systemd
systemctl daemon-reload
```

- Verify that the server starts

```bash
systemctl start factorio
systemctl status -l factorio
# Remember to enable the service at startup if you want that:
systemctl enable factorio
```

Note that systemd won't be able to keep track of the server process if you use this script to restart during updates. Use the config option ```UPDATE_PREVENT_RESTART=1``` and implement your own stop/start logic to work around this.

### SysvInit

- Symlink the init script:

```bash
ln -s /opt/factorio-init/factorio /etc/init.d/factorio
# Make the script executable:
chmod +x /opt/factorio-init/factorio
# Try it out:
service factorio help
# Do not forget to enable the service at boot if you want that.
```

## Contributing

When contributing to this repo, please ensure your contribution is covered by at least one test in ```test/factorio.bats``` or the very least: do not create pull requests with failing tests, thank you.

### Test the code

Testing is done using [bats-core](https://github.com/bats-core/bats-core), [bats-assert](https://github.com/ztombol/bats-assert) and [bats-support](https://github.com/ztombol/bats-support).

- Write a test case, example:

```bash
@test "DEBUG=1 produces output" {
    # To access functions within ./factorio, source it then use the run command:
    source ./factorio
    export DEBUG=1
    run debug "TEST"
    # use the various asserts from bats-assert
    assert_output "DEBUG: TEST"
}
```

- init and update the submodules (if you did not already)

```bash
git submodule init
git submodule update
```

- Then run the tests, see the following sections:

#### With .githooks

- Set the hooks path to our .githooks directory

```bash
git config --local core.hooksPath .githooks
```

The ```.githooks/pre-commit``` will run shellcheck, local tests as well as docker tests with and without resources.

#### With Docker

- Build the docker image (a slightly modified ubuntu by default)

```bash
docker build --build-arg factorio_version=1.0.0 --tag finit:latest .
```

Adding ```--target no-test-resources``` to the build command will avoid downloading test resources online but it will also skip tests that rely on the resources(!)

- Then run the image, mounting the current directory and removing the container once it's done

```bash
docker run -it --rm -v "$(pwd):/opt/factorio-init" --workdir /opt/factorio-init finit:latest test
```

#### Manually

Please note that some tests will be skipped unless you run them with the docker image or via .githooks, but running them manually is a quick way to get started.

- run the tests

```bash
./tests/libs/bats-core/bin/bats test
```

Using [parallel](https://www.gnu.org/software/parallel), adding ```--jobs 10``` to the above (adjust the number accordingly) will allow you to execute more tests in parallel and in turn possibly decrease the total time required to complete the run.

## Thank You

- To all who find this script useful in one way or the other
- A big thank you to [Wube](https://www.factorio.com/game/about) for making [Factorio](https://www.factorio.com/)
- A special thanks to NoPantsMcDance, Oxyd, HanziQ, TheFactorioCube and all other frequent users of the [#factorio](irc://irc.esper.net/#factorio) channel @ esper.net
- Thank you to Salzig for pointing me in the right direction when it comes to input redirection
- At last, but not least; Thank you to all [contributors](https://github.com/Bisa/factorio-init/graphs/contributors) and users posting [issues](https://github.com/Bisa/factorio-init/issues) in my [github](https://github.com/Bisa/factorio-init/) project or on the [factorio forums](https://forums.factorio.com/viewtopic.php?f=133&t=13874)

You are all a great source of motivation, thank you.

## License

This code is realeased with the MIT license, see the LICENSE file.
