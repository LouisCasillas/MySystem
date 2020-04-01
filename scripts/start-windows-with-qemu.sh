# install
qemu-system-x86_64 -boot order=d -enable-kvm -m 4096 -nic user,model=virtio -drive file=/dev/sda,format=raw -cdrom /mnt/bigbrain2/isos/Win10_1809Oct_v2_English_x64.iso -sdl
# run normally
#qemu-system-x86_64 -enable-kvm -m 4096 -nic user,model=virtio -drive file=/dev/sda,format=raw -sdl
