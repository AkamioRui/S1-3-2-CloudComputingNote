Q:

- can you clone any .git folder? yes
- in service, WantedBy and After
- it should be possible to send a packet in a LAN with just L2-L1 header packet, and nothing else
- netplan apply doesnt work but netplan work why?

- in OSI when does host choose which nic to send
- at what stage does nftables plays a role in the OSI stack? it must be before,at,after passing through routing table
- how to send packet :
    - use a specific ip (modify saddr, as if a container), to itself (but the daddr is still google.com)
    - (opt)using a specific nic

- network tap? hardware or software? isn't it suppose to sniff a network, how come it become a virtual NIC?
- QEMU has a few [network backend?]. The SLIRP backend is implemented for user-mode and does not support intercommunication among VMs. To connect VMs together, we need [host-supported network drivers?] (at least layer 2 support).

RuiMakaGithubioWibowo11062005

- qemu-w64-setup-20251217.exe; why can I extract it even though its an exe

- what is a proxy to connect to the internet? and how do I set that up










>A:
## OpenStack

- Linux use ip tuntap to create TAP devices (one per VM). so does it not need to add --netdev tap?
## VM network
- to gain internet access: the VM guest need to see/emulate a NIC [guest_frontEnd], and it need to have the interface with outside [host_backEnd]
    - the emulated device/[guest_frontEnd] can be:
        - `e1000`
        - `virtio-net-pci`. dhcp will be handled by qemu?
    - in qemu, the nic command attach a "physical emulator" to the VM guest. [host_backend] choice:
        - `user`/`SLIRP`. a host port will act as a port of the guest's nic
        - `tap`. create L2 connection between guest_nic and host_tap
            - mac first byte need to be unicast (%2=1)
        - `socket`

- some interface might not be running > invisible in ifconfig. run it with ` ip link set (network) up`
    -  more in [note_tapSetup.sh]
- to set up a virtual network
    - -[net] (old). Create both guest_frontEnd or host_backend
        - host_backend and guest_frontEnd are connected indirectly. those are all connected to VLAN[Hub#0], you can change to what hub each interface connect with. 
        - direct connection may be required, so This indirect connection will be a problem
    - -[netdev] (old). Create only host_backend, use -device to add guest_backend
        - host_backend and guest_frontEnd are directly connected
    - -[nic]. Create `both` guest_frontEnd and host_backend
## [wt]
- syntax: wt [-p "cmd/ps" -d "cwdir" command];[];[]
- ';' is interpreted as a delimiter, separate into another tab. so `wt cmd1; cmd2` ==> tab1 cmd1, while tab2 cmd2
- in command parameter use `cmd /c` for multiline
## [INF] 
- ==> a INI for window. INI is a plaintext config file
- fileExplorer [install] only register the driver. 
    - if there is hardware (e.g because its virtual) that matches driver's hardware ID it will be automatically binded to a hardware > show in the device manager; 
    - deviceManager/addlegacy will remember store inf info in C:\Windows\System32\DriverStore\FileRepository\ .you can even delete the inf file
- DevMan > [addlegacy]. forces to bind the driver to a device (can be not real). 
    - step 2 register the driver, it will show in the driver option to add
    - if it doesnt, browse the inf file
## [virtio]
- ==> an interface between vm and virtual device
- appear in guest as PCI bus. it simplifies the virtual device on the guest end, and the setup and maintenence is handed to the host.
 
## disk management
device level
- [lsblk]. this display all connected storage device
    - [mountPoint] of a [partition] = the folder that store its content in that partition
        - this include its childern, unless that children already has its own mountpoint

partition level
- [parted] 
    - take a `blockDevice (b)` file from /dev/ that represent a `disk`
    - resizepart 2 12G
    - resizepart 2 100%

filesystem level
- [resize2fs] PARTITION
- [df] -h. to see used space (for parted)



