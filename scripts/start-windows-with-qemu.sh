# install
qemu-system-x86_64 -boot order=d -enable-kvm -m 4096 -nic user,model=virtio -drive file=/dev/nvme1n1,format=raw -cdrom /home/oxaric/Downloads/W10X64.PRO.ENU.JAN2021.iso -sdl
# run normally
#qemu-system-x86_64 -enable-kvm -m 4096 -nic user,model=virtio -drive file=/dev/sda,format=raw -sdl
