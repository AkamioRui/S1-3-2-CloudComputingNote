
## LXD
- *QnA*
    - LXD clustering?
    - storage pool?
    - storage backend?
    - btrfs, LVM ?
    - empty block device?
    - loop device?
    - MAAS server?
    - stale cached image?
    - YAML "lxd init" preseed

- installing
    - `snap install lxd `
    - `lxd init`
- lxd command
    - create  -->
        - `lxc init $type $name`
        - `lxc launch $type $name` (create + start)
    - destroy -->`lxc delete $name`
    
    - start   -->`lxc start $name`
    - stop    -->`lxc stop $name`
    - restart -->`lxc restart $name`
    
    - exec    -->`lxc exec $name -- $cmd` 
    - attch   -->`lxc exec $name -- bash` 
    
    - ls      -->`lxc ls` 
        - ls net  -->`lxc network list` 
        - ls ISO  -->`lxc image list $remote:`
        - ls remote -->`lxc remote list` 
    - config  -->`lxc config show $container`
        - `lxc info $container`
        - `lxc config set $container $container.propery.name=$value`
    
    - file transfer
        - `lxc file push $file $cont/$fileInCont`    
        - `lxc file pull $cont/$fileInCont $file`
    - *unverivied* create access remote LXD
        - (in remote) `lxc config set core.https_address :$any_port`
        - (in remote) `lxc config set core.trust_password $passwd`
        - `lxc remote add $remote_name $ip:$port`
    - host forward
        - `lxc config device add $cont_name $*dev_name proxy listen=tcp:0.0.0.0:$*host_port connect=tcp:127.0.0.1:$*cont_port` 
    - profile
        - list - create - delete
        - show - edit
        - add - remove
    - snapshot/overlay --> `lxc snapshot $cont $ss_name`
- feature:
    - cloud config
