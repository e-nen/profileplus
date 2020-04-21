# profileplus
Shell environment supplement suite

## Overview
This project mainly aims to consolidate all of the shell customizations many of the contributors have applied individually to their boxes over the years. The goal is to have the ability to highly customize your shell environment with little hassle.

## Quick Install
To install simply run the following as root. If you don't trust using curl as root you can examine the source code to the remote 
installer first or clone the git repo yourself and run the install.sh script.

```bash
curl https://raw.githubusercontent.com/e-nen/profileplus/master/remote-install.sh | bash
```

Once it is installed you must run the following as root to configure profileplus.

```bash
/etc/profileplus/configure.sh
```

## Quick Update
To update simply run the following as root.

```bash
cd /etc/profileplus
git pull
```

## Modules
All of the value in profileplus comes from the ability to apply several modules to an environment with a single launcher thats executed with the standard shell profile.

### aliases.sh

### prompt.sh
The prompt module provides a very simple but sexy prompt customization selection. Currently there are nearly 30 static custom prompts available. Eventually this will be extended with the ability to dynamically configure your own custom prompts. Also includes a simple script to set the terminal bar title. Eventually this will support customization of the information being displayed.

### protectshellconfigs.sh
A simple script to check and fix user shell configuration file issues. It also protects the /etc/skel versions of the files. Eventually this will be extended to enforce much stricter permissions and make the files immutable, in an attempt to prevent tampering.

### rlog.sh and rlogupdate.sh
The rlog module provides a very simple but useful restricted shell logging environment. It moves the standard location of user shell logs into one central location, enforces strict permissions, and sets the variables read-only in the shell environment to prevent unset'ing them. It also customizes the size, length and format of the shell history logs to provide greater fidelity. This module is not intended as a secure logging solution, but simply as a way to preserve as much of your shell history as possible and make it available. For a more secure logging solution consider something like bash logger or kernel based exec() logging that are sent to a remote host.

### shopt.sh
A simple script to set shell options (shopt) that are commonly required by many of the other profileplus modules.

### os-update.sh
A script to perform OS updates on many different Linux distributions.
