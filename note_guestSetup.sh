# ------------------------setting Tap (in .bashrc)-------------------------

# run tap network
ip link set enp0s3 up 
# add ip addr to tap network
ip addr add 192.168.100.1/24 dev enp0s3

# diagnosis
arping -I eth1 192.168.100.2 #??????
arp -n #find other's ip and their mac

# art from https://patorjk.com/software/taag/#p=display&f=Graffiti&t=d-1+&x=none&v=4&h=4&w=80&we=false

