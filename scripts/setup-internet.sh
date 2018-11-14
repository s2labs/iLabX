#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Usage: $ sudo ./setup-internet.sh"
  exit
fi

echo "Please make sure that the CORE network setup is NOT yet running."
echo "Once you are ready press ENTER to continue"
read input

# enable module for dummy interfaces
modprobe dummy

interfaces=$(ip l show)
# add a dummy interface named internet <-- must be named the same as in the core setup
if ! echo $interfaces | grep -q -- "internet";then
  ip l add internet type dummy
fi

# delete the dummy0 interface that was automatically created
if echo $interfaces | grep -q -- "dummy0";then
  ip l del dummy0
fi

# enable IP forwarding
sysctl -w -q net.ipv4.ip_forward=1

# enable NAT for the vLabs external Interface
if ! iptables-save | grep -q -- "-A POSTROUTING -o enp0s3 -j MASQUERADE"; then
  iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
fi

echo "Please start the CORE setup now."
echo "The script will automatically check whether core is running and continue automatically."
while : ; do
sleep 5
  # get the name of the bridge between the core gateway and the internet dummy interface
  bridge=$(brctl show | grep -o '\bswitch-\w*')
  if [[ $bridge != "switch-"* ]]
  then
    echo "core not running" 
  else
    # to be sure wait some more seconds, not sure if required
echo "Setup is running, continuing with the Internet setup."
    sleep 5
    break
  fi
done

# configure the bridge with the correct IP address
ip addr add 10.0.0.2/24 dev $bridge

echo "Setup finished, If your VM has Internet access all hosts in CORE should now also have Internet access."
echo "If you restart the setup, make sure that you also run this script again."
