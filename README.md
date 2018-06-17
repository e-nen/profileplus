# profileplus
An extensible shell environment supplement suite

## Overview
This project mainly aims to consolidate all of the shell customizations and scripts many of the contributors have applied individually to their boxes over the years. The goal is to have the ability to highly customize your shell environment with little hassle.

## Quick Install
To install simply run the following. If you don't trust using curl as root you can examine the source code to the remote installer first.

```bash
sudo curl https://raw.githubusercontent.com/e-nen/profileplus/master/sbin/remote-install.sh | bash
```

Once it's installed you must run the following to configure profileplus.

```bash
sudo /etc/profileplus/sbin/configure.sh
```

Alternatively, if you prefer a local install, clone the git repo and run the install.sh script.

```bash
git clone https://github.com/e-nen/profileplus.git
cd profileplus/sbin
sudo ./install.sh
```

## Quick Update
To update simply run the following as root.

```bash
cd /etc/profileplus
git pull
```

To validate your configuration (updates may at times make additions and changes to the format) you can run the following as root.

```bash
/etc/profileplus/sbin/config-check.sh
```

## Modules
All of the value in profileplus comes from the ability to apply several modules to an environment with a single launcher thats executed with the standard shell profile.

### beep.sh
A simple script to use the advanced PC speaker beep application to create audio alerts.

### checksec.sh
A very useful script written to examine a hosts security mitigations.

### clock.sh
A simple clock display (that updates) in your terminal.

### firewise.sh
Firewise attempts to make some interfaces of iptables easier to use. I am unsatisfied with the configurations of many standard "firewall" suites/applications for iptables and use some customizations that they do not support. Firewise can create a "first" firewall for you to use. If your distribution does not support the use of iptables-save and iptables-restore as part of your boot init process, you may need to customize your init scripts slightly. Firewise also simplifies some relatively simple actions that would require a lot of typing otherwise. Some of these include flushing all rules and custom chains, listing all rules from all tables with line numbers, shunning a host, a panic mode that blocks all communications, and a log cooking utility to provide firewall statistics.

### gentooupdate.sh
A script to simplify daily usage of Gentoo Linux's portage system. It also adds the ability to automate some common functionality like sync'ing portage and reporting available updates via crontab.

### grsec.sh
A script to simplify daily usage of Grsecurity's functions. It gives you the ability to control some features via sysctl, paxctl/chpax, and gradm. It will eventually help fully automate RBAC implementations through full learning mode, role creation and appending ACLs per application.

### loadbar.sh
The loadbar script creates an additional layer to your prompt to display vital system statistics like CPU, memory, and disk usage.

### locate.sh and updatedb.sh
The locate suite is a very quick and dirty implementation designed to solve simple use cases for finding file/directory locations when the mlocate/slocate applications have not been installed on a system.

### permcheck.sh
The permcheck script helps to identify dangerous file/directory permissions and help resolve the issues.

### prompt.sh
The prompt module provides a very simple but sexy prompt customization selection. Currently there are nearly 50 static custom prompts available. Eventually this will be extended with the ability to dynamically configure your own custom prompts.

### protectshellconfigs.sh
A simple script to check and fix user shell configuration file issues. It also protects the /etc/skel versions of the files. Eventually this will be extended to enforce much stricter permissions and make the files immutable, in an attempt to prevent tampering.

### rlog.sh and rlogupdate.sh
The rlog module provides a very simple but useful restricted shell logging environment. It moves the standard location of user shell logs into one central location, enforces strict permissions, and sets the variables read-only in the shell environment to prevent unset'ing them. It also customizes the size, length and format of the shell history logs to provide greater fidelity. This module is not intended as a secure logging solution, but simply as a way to preserve as much of your shell history as possible and make it available. For a more secure logging solution consider something like bash logger or kernel based exec() logging that are sent to a remote host.

### shopt.sh
A simple script to set shell options (shopt) that are commonly required by many of the other profileplus modules.

### solarisprtdiag.sh
A simple script to run the Solaris prtdiag utility at login to check for hardware issues and if a problem exists print out the results of prtdiag.

### ssh-tool.sh
The ssh-tool module helps manage your OpenSSH client and server settings and keys. It will help you generate moduli and keys for a server and also public keys for clients. It is also recommends sshd_config file changes to help harden your server. Clients are able to easily manage entries in the ssh_config. Eventually this may also simplify using ssh-agent.

### ssl-tool.sh
The ssl-too module helps manage self-signed SSL certificates (currently with OpenSSL but eventually also LibreSSL). This tool will simplify the creation of a CA using the most hardened possible configuration. It can also issue and sign CSR's. Eventually this will also support many more options and likely letsencrypt.

### termbar.sh
A simple script to set the terminal bar title. Eventually this will support customization of the information being displayed.
