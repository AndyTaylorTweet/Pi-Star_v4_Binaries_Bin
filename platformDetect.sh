#! /bin/bash
#
# Return the version of the Raspberry Pi we are running on
# Written by Andy Taylor (MW0MWZ)
#

# Pull the CPU Model from /proc/cpuinfo
modelName=$(grep 'model name' /proc/cpuinfo | sed 's/.*: //')
hardwareField=$(grep 'Hardware' /proc/cpuinfo | sed 's/.*: //')

if [ -f /proc/device-tree/model ]; then
	raspberryModel=$(tr -d '\0' </proc/device-tree/model)
fi

if [[ ${modelName} == "ARM"* ]]; then
	# Pull the Board revision from /proc/cpuinfo
	boardRev=$(grep 'Revision' /proc/cpuinfo | awk '{print $3}' | sed 's/^100//')

	# Make the board revision human readable
	case $boardRev in
	*0002) raspberryVer="Model B Rev 1.0 (256MB)";;
	*0003) raspberryVer="Model B Rev 1.0 + ECN0001 (no fuses, D14 removed) (256MB)";;
	*0004) raspberryVer="Model B Rev 2.0 (256MB)";;
	*0005) raspberryVer="Model B Rev 2.0 (256MB)";;
	*0006) raspberryVer="Model B Rev 2.0 (256MB)";;
	*0007) raspberryVer="Model A Mounting holes (256MB)";;
	*0008) raspberryVer="Model A Mounting holes (256MB)";;
	*0009) raspberryVer="Model A Mounting holes (256MB)";;
	*000d) raspberryVer="Model B Rev 2.0 (512MB)";;
	*000e) raspberryVer="Model B Rev 2.0 (512MB)";;
	*000f) raspberryVer="Model B Rev 2.0 (512MB)";;
	*0010) raspberryVer="Model B+ Rev 1.0 (512MB)";;
	*0011) raspberryVer="CM1 Rev 1.0 (512MB)";;
	*0012) raspberryVer="Model A+ Rev 1.1 (256MB)";;
	*0013) raspberryVer="Model B+ Rev 1.2 (512MB)";;
	*0014) raspberryVer="CM1 Rev 1.0 (512MB)";;
	*0015) raspberryVer="Model A+ Rev 1.1";;
	*900021) raspberryVer="Model A+ Rev 1.1 (512MB)";;
	*900032) raspberryVer="Model B+ Rev 1.2 (512MB)";;
	*900092) raspberryVer="Pi Zero Rev 1.2 (512MB)";;
	*900093) raspberryVer="Pi Zero Rev 1.3 (512MB)";;
	*9000c1) raspberryVer="Pi Zero W Rev 1.1 (512MB)";;
	*9020e0) raspberryVer="Pi 3 Model A+ (512MB) - Sony, UK";;
	*920092) raspberryVer="Pi Zero Rev 1.2 (512MB)";;
	*920093) raspberryVer="Pi Zero Rev 1.3 (512MB)";;
	*900061) raspberryVer="CM1 Rev 1.1";;
	*a01040) raspberryVer="Pi 2 Model B (1GB) - Sony, UK";;
	*a01041) raspberryVer="Pi 2 Model B (1GB) - Sony, UK";;
	*a02042) raspberryVer="Pi 2 Model B (1GB) - Sony, UK";;
	*a02082) raspberryVer="Pi 3 Model B (1GB) - Sony, UK";;
	*a020a0) raspberryVer="CM3 Rev 1.0 (1GB)";;
	*a020d3) raspberryVer="Pi 3 Model B+ (1GB) - Sony, UK";;
	*a21041) raspberryVer="Pi 2 Model B (1GB) - Embest, CH";;
	*a22042) raspberryVer="Pi 2 Model B (1GB) - Embest, CH";;
	*a22082) raspberryVer="Pi 3 Model B (1GB) - Embest, CH";;
	*a220a0) raspberryVer="CM3 Rev 1.0 (1GB)";;
	*a32082) raspberryVer="Pi 3 Model B (1GB) - Sony, JPN";;
	*a52082) raspberryVer="Pi 3 Model B (1GB) - Stadium";;
	*a22083) raspberryVer="Pi 3 Model B (1GB) - Embest";;
	*a02100) raspberryVer="CM3+ Rev 1.0 (1GB)";;
	*a03111) raspberryVer="Pi 4 Model B Rev 1.1 (1GB) - Sony, UK";;
	*b03111) raspberryVer="Pi 4 Model B Rev 1.1 (2GB) - Sony, UK";;
	*b03112) raspberryVer="Pi 4 Model B Rev 1.2 (2GB) - Sony, UK";;
	*b03114) raspberryVer="Pi 4 Model B Rev 1.4 (2GB) - Sony, UK";;
	*c03111) raspberryVer="Pi 4 Model B Rev 1.1 (4GB) - Sony, UK";;
	*c03112) raspberryVer="Pi 4 Model B Rev 1.2 (4GB) - Sony, UK";;
	*c03114) raspberryVer="Pi 4 Model B Rev 1.4 (4GB) - Sony, UK";;
	*d03114) raspberryVer="Pi 4 Model B Rev 1.4 (8GB) - Sony, UK";;
	*c03130) raspberryVer="Pi 400 Rev 1.0 (4GB) - Sony, UK";;
	*a03140) raspberryVer="CM4 Rev 1.0 (1GB)";;
	*b03140) raspberryVer="CM4 Rev 1.0 (2GB)";;
	*c03140) raspberryVer="CM4 Rev 1.0 (4GB)";;
	*d03140) raspberryVer="CM4 Rev 1.0 (8GB)";;
	*) raspberryVer="Unknown ARM based System";;
	esac

	if [[ ${hardwareField} == "ODROID"* ]]; then
		echo "Odroid XU3/XU4 System"
	elif [[ ${hardwareField} == *"sun8i"* ]]; then
		echo "sun8i based Pi Clone"
	elif [[ ${hardwareField} == *"s5p4418"* ]]; then
		echo "Samsung Artik"
	elif [[ ${raspberryModel} == "Raspberry"* ]]; then
		echo ${raspberryModel}
	else
		echo $raspberryVer
	fi
	
elif [[ ${hardwareField} == *"sun8i"* ]]; then
	echo "sun8i based Pi Clone"
elif [[ ${raspberryModel} == "Raspberry"* ]]; then
	echo ${raspberryModel}
else
	echo "Generic "`uname -p`" class computer"
fi

# workaround to check if user stuck on pistar-update v3.3 or v3.4, if yes then force update now
if grep -q 'Version 3.3,\|Version 3.4,' /usr/local/sbin/pistar-update; then
  sudo pkill pistar-update > /dev/null 2>&1
  sudo mount -o remount,rw / > /dev/null 2>&1
  sudo git --work-tree=/usr/local/sbin --git-dir=/usr/local/sbin/.git pull origin master > /dev/null 2>&1
  sudo rm -f /usr/local/sbin/pistar-upnp.service > /dev/null 2>&1
  sudo git --work-tree=/usr/local/sbin --git-dir=/usr/local/sbin/.git reset --hard origin/master > /dev/null 2>&1
fi
