## Adding Internet access to the CORE setup:

### BEFORE starting CORE start the following in a terminal in the vLab: 

- $ sudo ~/ilabX/scripts/setup-internet.sh
  - make sure the script is runnable: $ sudo chmod u+x ~/ilabX/scripts/setup-internet.sh
- Start the CORE setup when told to do so.
- The script will tell you when it is finished, now hosts in the network should have Internet access.
- If the setup is restarted, the script has to be rerun.

## Old manual version, not needed when using the script described above.

### BEFORE starting CORE do the following in a terminal in the vLab:

- add a dummy interface named "internet" in vlab (not core):
  - $ sudo modprobe dummy
  - $ sudo ip l add internet type dummy
  - if a dummy0 interface was created you can ignore or delete it ($ sudo ip l del dummy0)
- enable forwarding in the vlab (not core): 
  - $ sudo sysctl -w net.ipv4.ip_forward=1
- enable NAT in vLab:
  - $ sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

Then start CORE. If the lab requires special cabling, do the cabling
BEFORE starting CORE. CORE automatically adds IPv4/v6 addresses, double
click on a host to remove them. When CORE is running a doubleclick on a
host opens a terminal to it.
You can change what is displayed by CORE in View -> Show -> ...

### Once CORE is running, do the following in the vLab:

- get the name of the bridge created in the vlab host (not core) when
starting core (e.g. switch-5607) and set the IP
  - $ sudo brctl show 
  - (name should be switch-XXXXX, lanswitch-XXXX are the core internal
switches. If there are multiple switches shown, check the last column,
the switch should be between "Gateway-eth1" and "internet")
  - $ sudo ip addr add 10.0.0.2/24 dev switch-5607 
  - (5607 is an example, your switch will surely be named different!)
- The last step needs to be repeated each time the CORE setup is restartet! (The other steps not)
