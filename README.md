# vmtime

## Details

This is a simple virtual machine time measurement tool (some scripts for that purpose to be precise).

These use the `virsh` command to start, restart as well as shut down virtual machines and measure the elapsed time.

## Usage

For example if you want to measure the restart time of the virtual machine named `FoobarLinux10` which has the IP address `192.168.1.10`, you need to run the following command on the host where the machine is running:

```bash
./vmtime-restart.sh FoobarLinux10 192.168.1.10
```

The other scripts use the same command-line arguments.
