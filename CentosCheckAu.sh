#!/bin/bash

# Author:   Eric M DONGMO
# Date:     August 2020
# CopyRight (c) ericmdongmo@gmail.com

# This script will be used to audit this server running on centOS 7.

#Authorized Users ; You have to be root

        if
		 [ $UID -ne 0 ] && [ $USER != root ]
then

echo "   You need eleveted privileges to run this script
         Stay away from this file
         Thank You "
exit
       fi

echo -e "\n##############################################################			\n"2>&1 |tee -a /tmp/${today}_project11.txt
echo -e "\n##################### CentOS 7 Audit #########################			\n" >> 2>&1 |tee -a /tmp/${today}_project11.txt
echo -e "\n##############################################################			\n"   >> 2>&1 |tee -a /tmp/${today}_project11.txt


today=`date +%Y-%m-%d_%H-%M-%S`; 

# File /etc/hosts
echo -e \n "Lookin for file \"hosts\", Please wait...\n"
sleep 2																				

	FILE1=/etc/hosts

    if   [ -f "$FILE1" ]
then
                echo "${FILE1} exists on this server."						2>&1 |tee -a /tmp/${today}_project11.txt
else
                echo "${FILE} does not exists on this server, check your spelling."		2>&1 |tee -a /tmp/${today}_project11.txt
    fi

#SELINUX status
echo -e "\n Checking for SELINUX status, Please wait ...\n"
sleep 2
        SELINUX=`grep ^\SELINUX= /etc/selinux/config | awk -F= '{print $2}'`
echo -e "\n This server has SELINUX set on \" ${SELINUX} \" \n"						2>&1 |tee -a /tmp/${today}_project11.txt

# User nobody
echo -e "\nChecking for nobody's UID, Please wait\n"
sleep 2
UID1=`cat /etc/passwd | awk -F: '/^nobody/ {print $3}'`

echo -e "\n nobody's UID is ${UID1} \n"									2>&1 |tee -a /tmp/${today}_project11.txt

#Package Samba
echo -e "\n Checking for Samba Package, please wait\n"
sleep 2
rpm -qa | grep samba	 									>> /tmp/${today}_project11.txt 2>&1
   
	 if
        [ $? -ne 0 ]
then
            echo -e "\n There's no Samba Package on this server\n"					2>&1 |tee -a /tmp/${today}_project11.txt
else
            echo -e "\n Samba Package is already instlled on this server\n"				2>&1 |tee -a /tmp/${today}_project11.txt
	fi

#Auditd Daemon
echo -e "\n Checking for \"auditd\" daemon's status, please wait...\n" 
sleep 2

STATUS=`systemctl status auditd | awk -F" " '{if(NR==3) print $2}'`				2>&1 |tee -a /tmp/${today}_project11.txt
echo -e "\n Auditd Daemon's is ${STATUS}\n" 								2>&1 |tee -a /tmp/${today}_project11.txt
systemctl status auditd | awk -F" " '{if(NR==3) print $2}'                                      2>&1 |tee -a /tmp/${today}_project11.txt

#Sudo logfile
echo -e "\nChecking for Secure file, please wait...\n"
sleep 2

test -f /var/log/secure
    if
        [ $? -eq 0 ]
then 
            echo -e "\n Sudo log messages are stored on \"secure\" file by default on this server\n"	2>&1 |tee -a /tmp/${today}_project11.txt
    else
            echo -e "\nThere is no Sudo logfile configured on this server\n"				2>&1 |tee -a /tmp/${today}_project11.txt
	fi

# Group file owner
echo -e "\nChecking for the Owner, please wait\n"

OWNER=`ls -l /etc |grep group | awk -F" " 'NR==1 {print $3}'`
												
	ls -l /etc |grep group | awk -F" " 'NR==1 {print $3}'					>> /tmp/${today}_project11.txt 2>&1
    if
        [ ${OWNER} == root ]
then
            echo -e "\nROOT is the owner for the \"group\" file \n"					2>&1 |tee -a /tmp/${today}_project11.txt

    else
            echo -e "\n ROOT is not the owner for the \"group\" file \n"					2>&1 |tee -a /tmp/${today}_project11.txt
	fi

#cURL
echo -e "\n Checking for cURL, please wait ...\n"

yum list installed '*curl*'									>> /tmp/${today}_project11.txt 2>&1
    if
        [ $? -eq 0 ]
then
            echo -e "\nWe have cURL installed on this Server\n"					2>&1 |tee -a /tmp/${today}_project11.txt
    else
            echo -e "\ncURL is not installed on this Server\n"						2>&1 |tee -a /tmp/${today}_project11.txt
	fi

# Docker
echo -e "\nChecking for DOCKER, please wait ...\n"
sleep 2
yum list installed '*docker*'									>> /tmp/${today}_project11.txt 2>&1
    if
        [ $? -eq 0 ]
then
            echo -e  "We have DOCKER installed on this Server\n"					2>&1 |tee -a /tmp/${today}_project11.txt
    else
            echo -e "\nDOCKER is not installed on this Server\n"					2>&1 |tee -a /tmp/${today}_project11.txt
	fi
#Total seize of memory
echo -e "\nchecking memory seize, please wait ... \n"
sleep 2
        MEMORY=`free -m | grep Mem | awk -F" "  '{print $2}'`

echo -e "\nThis server has \"${MEMORY}\" Mega Bytes\n"							2>&1 |tee -a /tmp/${today}_project11.txt

# Kernel Version
echo -e "\nChecking for the first digit of the Kernel Version, please wait ...\n"
KERNEL=`uname -r | awk -F"." '{print $1}'`		
											
echo -e "\nThe first digit of the Kernel Version for this server is \"${KERNEL}\" \n"			2>&1 |tee -a /tmp/${today}_project11.txt

# System Achitecture
echo -e "\nChecking for System Architecture, please wait ...\n"
sleep 2
        ARCH=`getconf LONG_BIT`

		echo -e "\n${ARCH} Bits is the Architecture of this server\n"				2>&1 |tee -a /tmp/${today}_project11.txt

# Network file
echo -e "\nChecking for Network file, please wait...\n"
sleep 2
test -f /etc/sysconfig/network
    if
        [ $? -eq 0 ]
then 
            echo -e "\nThis server has a file called \"network\" on /etc/sysconfig/network\n"		2>&1 |tee -a /tmp/${today}_project11.txt
    else
            echo -e "\nThis server doesn't have a file called \"network\" \n"				2>&1 |tee -a /tmp/${today}_project11.txt
	fi
# DNS
echo -e "\nChecking for DNS...\n"

    if 
        grep -q 8.8.8.8  /etc/resolv.conf							>> /tmp/${today}_project11.txt 2>&1
then
            echo -e "\nWe have a 8.8.8.8 DNS set on /etc/resolv.conf file on this server\n"		2>&1 |tee -a /tmp/${today}_project11.txt
    else
            echo -e "\nWe don't have 8.8.8.8 DNS set on this server\n"					2>&1 |tee -a /tmp/${today}_project11.txt
    fi

# IP Address
echo -e "\nLooking for IP Address ...\n"
sleep 2

        IPADD=`ip -4 -o addr show enp0s3 | awk '{print $4}'`

echo -e "\nThe IP Address of this server is \"${IPADD}\n"						2>&1 |tee -a /tmp/${today}_project11.txt

# Linux Flavor

	FLAVOR=`cat /etc/os-release | grep NAME | awk -F= 'NR==1 {print $2}'`	
        VERSION=`cat /etc/os-release | grep -oP "[0-9]+" | head -1`

echo -e "\n${FLAVOR} is the Flavor of this Server \n"							2>&1 |tee -a /tmp/${today}_project11.txt
echo -e "\n${VERSION} is the Version of this Server\n"			        			2>&1 |tee -a /tmp/${today}_project11.txt
 

#Hostname

echo -e "\nChecking for Hostname\n"
sleep 2

echo -e "\n\"${HOSTNAME}\" is the Hostname for this server\n"						2>&1 |tee -a /tmp/${today}_project11.txt


echo -e "\nCompleting program, please wait... \n"
sleep 1
echo -e "\nGenerating a report file...\n"

for pc in $(seq 1 100); do
    echo -ne "$pc%\033[0K\r"
    sleep 0.05
done
echo "completed"
sleep 0.5
echo -e "\nTransfering file to $HOME directory\n"

for pc in $(seq 1 100); do
    echo -ne "$pc%\033[0K\r"
    sleep 0.03
done

cp /tmp/${today}_project11.txt /$HOME

echo "\ncompleted\n"
