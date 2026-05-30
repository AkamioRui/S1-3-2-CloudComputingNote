>Q:
- what is a repository key

## lxc
- lxcbr0
    - it's both a bridge and a gateway(forward to 10.0.2.15)
- a container image (not OS iso image) is actually a folder, so it can't be overlay-ed
- netplan apply doesnt work but netplan work

## troubleshooting lxc
- [lxc-create] unknown key: apt intall debian-archive-keyring
- [lxc-start]
    - (opt)`-F`, put the container in the foreground
    - (opt)`-l TRACE`, dump the trace. (TRACE is the level, there is also DEBUG and INFO )
- [lxc-stop]
    - (opt)`-F`, put the container in the foreground

## ***unverivied*** creating overlays containers
- mkdir in lxc: new-container/
- mkdir in new-container (a rootfs_folder): delta/
- touch in lxc: config
    - lxc.rootfs.path=overlayfs:/base:/delta
    - lxc.uts.name = new-container
    (consult the setting of the base lxc)


## storage
- in LINUX, storage are 2 layers:
    - lvm. 
        - PV -|combined|-> VG -|split|-> LV 
    - fs: 
- ZFS, handle lvm + fs layer

