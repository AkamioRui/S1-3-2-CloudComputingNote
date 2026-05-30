## network fundamental
- for a collection of NIC that is connected in a network(has a way to send data to eachother), the requirement to create a network is just to have a unique MAC and IP

- (L1)**hub**. takes a packet in one of its port and retransmit/repeat to other
- (L2)**bridge**. only has few port (software based), takes a packet from one ;and based on the mac, forward it to the other port 
- (L2)**switch**. better bridge (more port and hardware based)
    - it have a `CAM table` that maps MAC ==> L2_PORT. (instead of an ARP since it cant see IP)
        - if a destination is not in CAM table, `unknown unicast flooding`: switch will send that packet to all port
    - if a port is connected to other switch, that port will maps to all MAC connected to that switch
        - thus, those LAN, it become 1 LAN
    - `VLAN`. the port can be assigned with VLAN ID, packet only forwarded to out_port with the same VLAN ID as in_port
        - in a system with multiple switch, `trunk port` a special port (between switches) that can carry packet from different VLAN (filtering is done in the destination switch)
    - it has a MAC, but other host won't use this MAC. its mac is for maintence(ssh)
    - it can have multiple IP for each 
- (L3) **pure router**. connects multiple LAN without merging
    - subnet must be in the same LAN
    - multiple subnet in a LAN will cause node to >switch>router>switch just to get to the same node in 
- **host**
    - (L2) it *doesnt* keep track of what MAC can each LL port can access
    - (L2/L3) it uses `ARP table`. the destintation MAC is not the switch MAC
        - when sending to a different LAN, uses router's IP
    - (L3) `routing table`
    - (L3) it decide which interface to use from the subnet

## virtual network
- **tap**
    - tun/tap are kernel space driver that send/receive packet from user space program (instead of from physical device)
        - tun send/receive IP datagram
        - tap send/receive frame
    - as `network listener`
    - as `vpn client`
    - as `virtual network interface`
        - guest and host see it as `NIC`
        - it won't be able to ping a window host because it's blocked by firewall.
            - ??? specifically of (insufficient) firewall > advance > inbound > file&printer sharing ICMP
        - the tap can modify its IP and mac once bridged because the bridge own the IP
- **virtual bridge**
    - [Linux] add bridge
        - ip link add $brName type bridge
            - ip link set $brName up
            - ip link set $brName address $macaddr
            - ip addr set $ipv4addr dev $brName 
            - ip link set $nic2beBridged master $brName 
    - [Linux] add persistant bridge
        - vi /etc/netplan:
            ```
            network:
                version: 2
                bridges:
                    br0:
                        (opt) interfaces:[$other_nic_or_tap]
                        (opt) addresses:[$ipv4] # plural, one for each vlan
                        (opt) macaddress:$mac
            ```
    - [linux] turn bridge into a router 
        - `sysctl -w net.ipv4.ip_forward=1` to allow forwarding received ip packet
            - *check* `sysctl -a`
        - `nft add rule $tablename $chainname $rule`
            - $rule for nat-ing is `ip saddr $subnet ip daddr $subnet masquerade`, 
                where the `ip saddr $subne`and `ip daddr $subnet` are conditions
            regardless of table name
            - (persistant)
                - in `/etc/nftables.conf`
                - `nft -f /etc/nftables.conf`
                - `systemctl restart nftables`
            - *check* `nft list ruleset` to see all nft ruleset, note that all chain will fire at specified hook 
        - `ip route add default via $this_ip` to update ip route
            - (persistant) 
                - in `/etc/netplan/*.yaml` add `routes: [{to: default, via: 10.0.4.1}]` 
                - `netplan apply`
            - *check* `ip route`
        - `resolvectl dns $nic 8.8.8.8` set dns to google dns
            - (persistant) in `/etc/systemd/resolved.conf` set `DNS=8.8.8.8`
            - (persistant) in `systemctl restart systemd-resolved`
            - *check* `resolvectl status`
    - [linux] (opt)create dns with dnsmasq
- **veth**
    - two endpoint that are L2(or below) connected
    - tap is userspace program <--> kernel, but veth is kernel_network_namespace_1 <--> kernel_network_namespace_2

- setting up in window
    - [find .inf](https://github.com/OpenVPN/tap-windows6/releases/download/9.27.0/dist.win10.zip)
    - in `device manager` 
        - click `network adapter` 
        - click `action` in the ribbon > `add legacy`. it will open a window
        - choose `manual install` > `network adapter` > `Have Disk`> choose the .inf > finished
    - in ncpa.cpl
        - rename adapter
        - double click. show current connection status(if not enabled, goes straight to properties)
        - properties. show persistant setting
            - if tap is connected to bridge, it wont show much option
            - you'd need to set IP and MAC to communicate
- tap has 2 side. the `app` (the thing that can connect to what ever) and the `network interface`
- in `ipconfig /all`, newly added tap will have `Description` as `TAP-Windows Adapter V9 ...`, once the tap has been added to bridge it will not show up




## scanning 
- IP
    
- MAC
    - `arp`. this only show cached
        - -i {interface} 
        - -a/-e
    - `nmap [Type] [Opt] {target}`
        - target = hostname,IP,subnet e.g. google.com
        - `--traceroute` show hop
        - specify port to scan
            - `-p` 
            - default 1000 top port 
            - `-p-` scan all port
            - `-sn` dont scan port (show no port)
        - `-sV` show version. This is collected from banner (layer 7 field)
        - `-A`

## window peculiarity
- `device manager` to add tap. I guess the logic is, adding and removing driver is here, configuring it will be in another app.
- `ncpa` and `setting > network&internet` if for configuring the network interface. 
    - Some feature only exist in one and some are shared. this is because it's still in the process of moving from `ncpa` to `setting > network&internet`
    


