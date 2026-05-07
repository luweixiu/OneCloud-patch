#!/bin/bash
#sudo apt-get install img2simg
chmod +x ./AmlImg
#本脚本将编译好的固件打包成线刷包固件
# ===================== 关键修改 =====================
# 直接使用你目录里现有的 uboot.img
# 完整解压并保留你的 uboot 分区信息
./AmlImg unpack ./uboot.img burn/
# ====================================================

#编译完成的固件路径
gzip -dk ./*.gz

diskimg_path="./*.img"
boot_img_name="immortalwrt.img"
boot_img_mnt="xd"
rootfs_img_mnt="img"

# 修复文件名换行问题（必加）
diskimg=$(ls -1 $diskimg_path | head -n 1 | tr -d '\n\r' | xargs)
prefix=$(echo "$diskimg" | sed 's/\.img$//')
burnimg_name="${prefix}-burn.img"

loop=$(sudo losetup --find --show --partscan "$diskimg" | sed 's/[^[:print:]]//g')

if [ -z "$loop" ]; then
  echo "Error: Failed to setup loop device."
  exit 1
fi
#空间大小
dd if=/dev/zero of="${boot_img_name}" bs=1M count=2048 status=progress
if [ $? -ne 0 ]; then
  echo "Error: Failed to create boot image."
  exit 1
fi

mkfs.ext4 -F "${boot_img_name}"
if [ $? -ne 0 ]; then
  echo "Error: Failed to format boot image."
  exit 1
fi

mkdir -p "${boot_img_mnt}" "${rootfs_img_mnt}"
sudo mount "${boot_img_name}" "${boot_img_mnt}"
if [ $? -ne 0 ]; then
  echo "Error: Failed to mount boot image."
  exit 1
fi

sudo mount "${loop}p2" "${rootfs_img_mnt}"
if [ $? -ne 0 ]; then
  echo "Error: Failed to mount rootfs partition."
  exit 1
fi

sudo cp -rp ${rootfs_img_mnt}/* "${boot_img_mnt}"
sudo sync

sudo umount "${boot_img_mnt}" || true
sudo umount "${rootfs_img_mnt}" || true
rm -rf "${boot_img_mnt}" "${rootfs_img_mnt}"

sudo img2simg "${loop}p1" burn/boot.simg
sudo img2simg "${boot_img_name}" burn/rootfs.simg
sudo rm -f "${boot_img_name}"

sudo losetup -d "$loop" || true

# 写入分区配置（uboot 已经从你本地文件导入）
printf "PARTITION:boot:sparse:boot.simg\nPARTITION:rootfs:sparse:rootfs.simg\n" >> burn/commands.txt

# 打包最终固件
./AmlImg pack "${burnimg_name}" burn/
sha256sum "${burnimg_name}" > "${burnimg_name}.sha"

# 压缩（解决内存不足）
xz -9 -T1 --compress "${burnimg_name}"

# 清理临时文件
rm -rf burn
rm ${diskimg_path}

echo "==================== 完成 ===================="
echo "✅ 使用你本地目录的 uboot.img 打包成功"
echo "✅ 刷机包：${burnimg_name}.xz"
echo "=============================================="
