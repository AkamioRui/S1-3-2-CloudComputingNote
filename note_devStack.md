1. run qemu (optional: create an overlay of the disk)
```bash
/e/vmShenanigans/CloudComputing/qemu$
./qemu-img.exe create -f qcow2 -b device1.img -F qcow2 THE_cloud/device1-1.img
    #why does -b relative to the result file?
E:
CD E:\vmShenanigans\CloudComputing\
qemu\qemu-system-x86_64.exe -M q35 -accel whpx,kernel-irqchip=off -accel hax -accel tcg -m 6G -drive file=qemu\THE_cloud\device1-1.img,if=virtio -nic user,model=e1000,hostfwd=tcp::11022-:22,hostfwd=tcp::11080-:80 -nic tap,ifname=myTap1,mac=52:54:00:00:00:01 -display default,show-cursor=on


 -nographic
```
2. 
```bash
    git clone https://opendev.org/openstack/devstack
cd devstack

```
3. 
```bash
    cp samples/local.conf local.conf
    vi local.conf
    # edit these:
    
    # ADMIN_PASSWORD: secret
    # DATABASE_PASSWORD: $ADMIN_PASSWORD
    # RABBIT_PASSWORD: $ADMIN_PASSWORD
    # SERVICE_PASSWORD: $ADMIN_PASSWORD
    
    # HOST_IP: 10.0.2.15
```
4. 
```bash
    ./stack.sh
```
5. troubleshoot 
- permission denied on /opt/stack. make sure the user that is installing has full access to /opt/stack
- devstack@etcd.service 
```bash
    sudo rm /opt/stack/bin/etcd
    mkdir test
    cd test
    curl -L https://github.com/etcd-io/etcd/releases/download/v3.5.12/etcd-v3.5.12-linux-amd64.tar.gz -o etcd.tar.gz
    tar xz -f etcd.tar.gz etcd-v3.5.12-linux-amd64/etcd --strip-components=1 
    sudo cp etcd /opt/stack/bin/etch
```
- some python error. most likely dependency issue
```bash
    source /opt/stack/data/venv/bin/activate
    pip list #find the version of the package that cause error

    #fit for all solution, remove /opt/stack/data/venv
```
- unable to create network
```bash
    source /opt/stack/data/venv/bin/activate
    pip list #find the version of the package that cause error

    #fit for all solution, remove /opt/stack/data/venv
```



    

rui@device1Server:~$ systemctl start devstack@etcd.service
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ====
Authentication is required to start 'devstack@etcd.service'.
Authenticating as: device1 (rui)
Password:
==== AUTHENTICATION COMPLETE ====
Job for devstack@etcd.service failed because the control process exited with error code.
See "systemctl status devstack@etcd.service" and "journalctl -xeu devstack@etcd.service" for details.
rui@device1Server:~$ systemctl status devstack@etcd.service
× devstack@etcd.service - Devstack devstack@etcd.service
     Loaded: loaded (/etc/systemd/system/devstack@etcd.service; enabled; preset: enabled)
     Active: failed (Result: exit-code) since Sat 2026-03-21 16:39:08 UTC; 17s ago
    Process: 3112 ExecStart=/opt/stack/bin/etcd --name device1Server --data-dir /opt/stack/data/etcd --initial-cluster-state new --initial-cluster-token et>
   Main PID: 3112 (code=exited, status=203/EXEC)
        CPU: 1ms

Mar 21 16:39:08 device1Server systemd[1]: Failed to start devstack@etcd.service - Devstack devstack@etcd.service.
Mar 21 16:39:08 device1Server systemd[1]: devstack@etcd.service: Scheduled restart job, restart counter is at 5.
Mar 21 16:39:08 device1Server systemd[1]: devstack@etcd.service: Start request repeated too quickly.
Mar 21 16:39:08 device1Server systemd[1]: devstack@etcd.service: Failed with result 'exit-code'.
Mar 21 16:39:08 device1Server systemd[1]: Failed to start devstack@etcd.service - Devstack devstack@etcd.service.
...skipping...
rui@device1Server:~$ journalctl -xeu devstack@etcd.service
░░
░░ An ExecStart= process belonging to unit devstack@etcd.service has exited.
░░
░░ The process' exit code is 'exited' and its exit status is 203.
Mar 21 16:39:08 device1Server systemd[1]: devstack@etcd.service: Failed with result 'exit-code'.
░░ Subject: Unit failed
░░ Defined-By: systemd
░░ Support: http://www.ubuntu.com/support
░░
░░ The unit devstack@etcd.service has entered the 'failed' state with result 'exit-code'.
Mar 21 16:39:08 device1Server systemd[1]: Failed to start devstack@etcd.service - Devstack devstack@etcd.service.
░░ Subject: A start job for unit devstack@etcd.service has failed
░░ Defined-By: systemd
░░ Support: http://www.ubuntu.com/support
░░
░░ A start job for unit devstack@etcd.service has finished with a failure.
░░
░░ The job identifier is 1491 and the job result is failed.
Mar 21 16:39:08 device1Server systemd[1]: devstack@etcd.service: Scheduled restart job, restart counter is at 5.
░░ Subject: Automatic restarting of a unit has been scheduled
░░ Defined-By: systemd
░░ Support: http://www.ubuntu.com/support
░░
░░ Automatic restarting of the unit devstack@etcd.service has been scheduled, as the result for
░░ the configured Restart= setting for the unit.
Mar 21 16:39:08 device1Server systemd[1]: devstack@etcd.service: Start request repeated too quickly.
Mar 21 16:39:08 device1Server systemd[1]: devstack@etcd.service: Failed with result 'exit-code'.
░░ Subject: Unit failed
░░ Defined-By: systemd
░░ Support: http://www.ubuntu.com/support
░░
░░ The unit devstack@etcd.service has entered the 'failed' state with result 'exit-code'.
Mar 21 16:39:08 device1Server systemd[1]: Failed to start devstack@etcd.service - Devstack devstack@etcd.service.
░░ Subject: A start job for unit devstack@etcd.service has failed
░░ Defined-By: systemd
░░ Support: http://www.ubuntu.com/support
░░
░░ A start job for unit devstack@etcd.service has finished with a failure.
░░
░░ The job identifier is 1586 and the job result is failed.
