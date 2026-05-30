@REM create disk: .\qemu-img.exe create -f qcow2 cloud/device1.img 10G
@REM .\qemu-system-x86_64.exe -cdrom ..\ubuntu-24.04.4-live-server-amd64.iso -m 4G -M q35 -accel whpx,kernel-irqchip=off -accel hax -accel tcg THE_cloud\device1.img

set qemu=qemu\qemu-system-x86_64.exe
set machine=-M q35 -accel whpx,kernel-irqchip=off -accel hax -accel tcg
set memory=-m 4G

