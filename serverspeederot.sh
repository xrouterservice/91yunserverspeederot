#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

clear
if [ ! -d "/serverspeeder" ]; then
  echo "You didn't Install ServerSpeeder"
  echo "Please Install ..."
fi

clear
echo
echo "#############################################################"
echo "# ServerSpeeder Optimization 1.0 For 91Yun ServerSpeeder    #"
echo "# Author: J2S016 233                                        #"
echo "# Thanks: @91Yun <https://91yun.org>                        #"
echo "#############################################################"
echo

Get_OS_Bit()
{
    if [[ `getconf WORD_BIT` = '32' && `getconf LONG_BIT` = '64' ]] ; then
        OS='x64'
		echo "OS Bit : x64"		
    else
        OS='x32'
		echo "OS Bit : x32"		
    fi
}

Get_Kernel_Version()
{
Kernel=`uname -r`
echo "Kernel Version : $Kernel"
}

Get_Dist_Name()
{
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt-get'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'		
	else
        DISTRO='unknow'
    fi
}

Check_OpenVZ()
{
echo "Checking System Virtualization..."
if [ -f /proc/user_beancounters ] || [ -d /proc/bc ]; then
virtualization=openvz
echo "Virtualization OS : $virtualization"
else
virtualization=kvmxen
echo "Virtualization OS : KVM or Xen"
fi
}

echo "**** Get System Infomation ****"
Get_Dist_Name
Get_OS_Bit
Get_Kernel_Version
Check_OpenVZ
IP=`curl -s http://members.3322.org/dyndns/getip`;
echo "IP is $IP"
echo "**** System Infomation End****"

echo "System information is correct? The correct return can not correctly please Ctrl+C stop"
read -p 

if [ "$DISTRO" == "CentOS" ]; then
	# CentOS
	yum install -y ppp
	fi
	if [[ "$DISTRO" == "Ubuntu" ]] || [[ "$DISTRO" == "Debian" ]]; then
	# Debian/Ubuntu
	apt-get install pptpd
	fi

cp /serverspeeder/etc/config /serverspeeder/etc/config.bak
sed -i "s/accppp=\"0\"/accppp=\"1\"/g" /serverspeeder/etc/config
# 高级入向加速
sed -i "s/advinacc=\"0\″/advinacc=\"1\"/g" /serverspeeder/etc/config
# 局域网加速 这个有点小必要
sed -i "s/subnetAcc=\"0\"/subnetAcc=\"1\"/g" /serverspeeder/etc/config

clear
echo "MEMINFO:"
echo 
free -m
echo "Please Input Mem Free:"
echo "For Exmple:"
echo "IF YOUR MEMINFO just like this:"
meminfo233="             
total       used       free     shared    buffers     cached
Mem:          1002        560        442          0        144        212
"
echo "$meminfo233"
echo "Mem free is 560"
echo "SO , Here in put 550"
memshiji="512"
read -p "Input MEM FREE(default 512): " memshiji
memserverspeeder2=`expr $memshiji \* 8`
echo $memserverspeeder2
memserverspeederall=`echo $memshiji $memserverspeeder2`
sed -i "s/l2wQLimit=\"256 2048\"/l2wQLimit=\"$memserverspeederall\"/g" /serverspeeder/etc/config
sed -i "s/w2lQLimit=\"256 2048\"/w2lQLimit=\"$memserverspeederall\"/g" /serverspeeder/etc/config
#sed -i "s/w2lQLimit=\"256 2048\"/w2lQLimit=\"512 4096\"/g" /serverspeeder/etc/config
sed -i "s/initialCwndWan=\"22\"/initialCwndWan=\"60\"/g" /serverspeeder/etc/config
bash /serverspeeder/bin/serverSpeeder.sh reload
bash /serverspeeder/bin/serverSpeeder.sh restart

echo "生效！"
