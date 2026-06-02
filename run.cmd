set qemu=qemu\qemu-system-x86_64.exe
set machine=-M q35 -accel whpx,kernel-irqchip=off -accel hax -accel tcg
set memory=-m 6G

@REM tap after user, for fast boot 
set device1=%qemu% %machine% %memory% ^
-drive file=qemu\cloud\device1.img,if=virtio ^
-nic user,model=e1000,hostfwd=::11022-:22,hostfwd=::11080-:80 ^
-nic tap,model=e1000,ifname=myTap1,mac=52:54:00:00:00:01 

set device2=%qemu% %machine% %memory% ^
-drive file=qemu\cloud\device2.img,if=virtio ^
-nic user,model=e1000,hostfwd=::12022-:22,hostfwd=::12080-:80 ^
-nic tap,model=e1000,ifname=myTap2,mac=52:54:00:00:00:02

set deviceTest=%qemu% %machine% %memory% ^
-drive file=qemu\cloud\ubuntu_test.img,if=virtio ^
-nic user,model=e1000,hostfwd=::11022-:22,hostfwd=::11080-:80 ^
-nographic ^
-nic tap,model=e1000,ifname=myTap1,mac=52:54:00:00:00:01

set lxd_Test=%qemu% %machine% %memory% ^
-drive file=qemu\cloud\ubuntu_lxd.img,if=virtio ^
-nic user,model=e1000,hostfwd=::11022-:22,hostfwd=::11080-:80 ^
-nographic

set podman_Test=%qemu% %machine% %memory% ^
-drive file=qemu\cloud\ubuntu_podman.img,if=virtio ^
-nic user,model=e1000,hostfwd=::11022-:22,hostfwd=::11080-:80,hostfwd=::13306-:13306,hostfwd=::8080-:8080 ^
-nographic



set k8s_Test=%qemu% %machine% %memory% ^
-drive file=qemu\cloud\ubuntu_k8s.img,if=virtio ^
-nic user,model=e1000,hostfwd=::11022-:22,hostfwd=::11080-:80 ^
-smp 2 ^
-nographic

@REM qemu/qemu-system-x86_64.exe -M q35 -m 4G -drive file=qemu/cloud/ubuntu_k8s.img,if=virtio -nic user,model=e1000,hostfwd=::11022-:22


@REM -virtfs local,path=/host/folder,mount_tag=hostshare,security_model=passthrough
@REM sudo mount -t 9p -o trans=virtio hostshare /mnt/shared




%k8s_Test%

@REM -nic tap,model=e1000,ifname=myTap1,mac=52:54:00:00:00:01
@REM the actual command. create 2 tab each running a device
@REM wt.exe ^
@REM -d "E:\vmShenanigans\CloudComputing" cmd /c "%device1%"; ^
@REM -d "E:\vmShenanigans\CloudComputing" cmd /c "%device2%"



@REM -nographic 
@REM -display default,show-cursor=on
@REM -netdev user,id=net0,hostfwd=tcp::8822-:22 ^
@REM -device e1000,netdev=net0 ^









