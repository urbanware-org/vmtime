# *VMtime*

## Definition

Simple and more or less useful virtual machine time measurement tool.

[Top](#vmtime)

## Details

The project consists of some scripts which use the `virsh` command to start, restart as well as shut down virtual machines and measure the elapsed time using `ping`. According to that, the virtual machine must be pingable by the host system on which these scripts are started.

Originally, *VMtime* was written for an experimental environment. Therefore, it is a very rudimentary tool that is only useful for a few constellations and environments (if at all).

This tool was uploaded here in case someone is interested in the code behind, which contains some unnecessary comments on what should be self-explanatory code.

[Top](#vmtime)

## Usage

For example, if you want to measure the restart time of the virtual machine named `FoobarLinux10` which has the IP address `192.168.1.10`, you need to run the following command on the host where the machine is running:

```bash
./vmtime-restart.sh FoobarLinux10 192.168.1.10
```

The other scripts use the same command-line arguments.

[Top](#vmtime)
