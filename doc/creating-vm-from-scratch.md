# Creating the EPICS Training VM

These instructions describe how to generate the VirtualBox VM
for the EPICS Training from scratch.
The recipe was set up using VirtualBox 7.0.14 on Windows 10,
but it should work similarly on other versions and host systems.

## Create the VM

Create a new virtual machine, using the Rocky Linux 9.3 DVD iso image.
Here are the settings we used.
More CPUs and memory always helps -
going lower than these values is not recommended.

![VBox Settings](/doc/training-vm-parameters.png?raw=true "VBox Settings")

Use a plain "Workstation" install,
no additional software modules are needed.

Create a user (we used epics-dev as the "EPICS Developer")
select "make administrator" (which enables sudo).
We did not set a password, which is fine for a personal VM
that you run on your own computer/laptop.

Consider saving the state in a snapshot, *"9.3 fresh"*.

## Update the system and install dependencies

Become root.
```
sudo -i
```

Enable EPEL and update the system.
```
dnf install epel-release && dnf update --refresh
```

Reboot (important!).

Install the prerequisites for building the VBox Guest Additions
```
dnf install dkms kernel-devel kernel-headers
```

Reboot.

It is useful to make another snapshot at this point, *"9.3 updated"*.

## Install the VBox Guest Additions

"Insert Guest Additions CD" in the VBox GUI and authorize autostart.

Reboot.

Create a snapshot *"9.3 with Guest Additions 7.0.14"*.

## Allow passwordless sudo

As root,
edit `/etc/sudoers` (by commenting / uncommenting lines)
to allow the `wheel` group to run commands with `NOPASSWORD: ALL`.
This is needed for ansible to run.

## Get and run the bootstrap script

Copy the script `bootstrap_redhat.sh` onto the VM and run it.

This will make sure the required software is installed (git, ansible)
and clone this repository with the ansible configuration
into a directory called `bootstrap`.

## Create your local configuration

Inside the `bootstrap/ansible/group_vars` directory,
copy the file `local.yml.sample` naming the copy `local.yml`.

Edit `bootstrap/ansible/group_vars/local.yml`
to configure your training VM.

## Run ansible to install the system

```
ansible-playbook -i bootstrap/ansible/hosts bootstrap/ansible/playbook.yml
```
will install the training VM according to your configuration.

The compiling jobs will take their time.
Subsequent ansible runs will not recompile modules unless necessary.
