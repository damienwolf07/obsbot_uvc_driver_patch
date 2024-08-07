echo "OBSBOT USB UVC Driver Patch"
echo "Updating APT package lists and installing required dependencies..."
sudo apt update
sudo apt install gcc cmake -y
sudo apt install linux-headers-$(uname -r) -y
echo "done. Now making the patched driver..."
cd $(pwd)/src
if [ ! -e "uvc.tar.gz" ]; then
    curl -o uvc.tar.gz "https://github.com/damienwolf07/obsbot_uvc_driver_patch/raw/main/src/uvc.tar.gz"
fi
tar xvf uvc.tar.gz
rm -rf uvc.tar.gz
make -C /usr/src/linux-headers-$(uname -r) M=$(pwd) modules
echo "done. Replacing the UVC kernel driver..."
sudo rm -f /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/*
sudo mkdir -p /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/
sudo cp uvcvideo.ko /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/
echo "done. Cleaning up..."
rm -rf ./*
cd ..
echo "done. Now reloading modules..."
sudo depmod -a
sudo modprobe uvcvideo
echo "Complete!"
echo "The driver is now patched! If the patch does not seem to work, Reboot with 'sudo reboot' and try again."
