#!/bin/bash


#Description: Centos7 Audit
#Author: Serge k , Eric D
#Date: August 2020
#script to display sstem info

echo -e "\n***********************************************\n" > /var/log/centos7audit-$(date +%F)
echo -e "\n*****  Centos 7 audit *********************\n" >> /var/log/centos7audit-$(date +%F)
echo -e "\n*****************************************\n"   >> /var/log/centos7audit-$(date +%F)

## Check hosts file

echo -e "\n Check the hosts file\n" >> /var/log/centos7audit-$(date +%F)
 if [ -f /etc/hosts ] ; then
    echo "File /etc/hosts exist" >> /var/log/centos7audit-$(date +%F)
 else
   echo "File /etc/hosts does not exist" >> /var/log/centos7audit-$(date +%F)
 fi

## CHeck Selinux

 
echo -e "\nChecking selinus\n" >> /var/log/centos7audit-$(date +%F)
echo -e "\n The selinux is set to $(getenforce) \n" >> /var/log/centos7audit-$(date +%F)

## nobody user' uid 

echo -e "\nCheck nobody's uid\n"
echo -e "\nThe user nobody's uid is $(grep ^nobody /etc/passwd|awk -F: '{print$3}') \n" >> /var/log/centos7audit-$(date +%F)

## Check for samba package

echo -e "\nChecking samba package\n" >> /var/log/centos7audit-$(date +%F)
rpm -qa |grep samba  >/dev/null 2>&1

  if [ $? -eq 0 ]; then 
     echo -e "\n Package samba installed\n" >> /var/log/centos7audit-$(date +%F)
  else 
     echo -e "\nPackage samba not installed\n" >> /var/log/centos7audit-$(date +%F)
  fi

## Check for curl package

echo -e "\nChecking curl package\n" >> /var/log/centos7audit-$(date +%F)
rpm -qa |grep curl  >/dev/null 2>&1

  if [ $? -eq 0 ]; then
     echo -e "\n Package curl installed\n" >> /var/log/centos7audit-$(date +%F)
  else
     echo -e "\nPackage curl not installed\n" >> /var/log/centos7audit-$(date +%F)
  fi
## Check for docker package

echo -e "\nChecking docker package\n" >> /var/log/centos7audit-$(date +%F)
rpm -qa |grep docker  >/dev/null 2>&1

  if [ $? -eq 0 ]; then
     echo -e "\n Package docker installed\n" >> /var/log/centos7audit-$(date +%F)
  else
     echo -e "\nPackage docker not installed\n" >> /var/log/centos7audit-$(date +%F)
  fi
## Checking the auditd

echo -e "\nChecking the auditd\n" >> /var/log/centos7audit-$(date +%F)
systemctl status auditd | grep Loaded | awk -F";" '{print " auditd is"$2}' >> /var/log/centos7audit-$(date +%F)
systemctl status auditd | awk 'NR ==3 {print "auditd is " $3}' | tr -d '()' >> /var/log/centos7audit-$(date +%F)
  
## Check network file

echo -e "\n Check the network file\n" >> /var/log/centos7audit-$(date +%F)
 if [ -f /etc/sysconfig/network ] ; then
    echo "File /etc/sysconfig/network exist" >> /var/log/centos7audit-$(date +%F)
 else
   echo "File /etc/sysconfig/network does not exist" >> /var/log/centos7audit-$(date +%F)
 fi
   
## Check hostname
echo -e "\nThe hostname for this server is $(hostname) \n" >> /var/log/centos7audit-$(date +%F)

##Check system bits
echo -e "\nthe system is $(getconf LONG_BIT) \n" >> /var/log/centos7audit-$(date +%F)

## 
