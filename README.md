# RHOSP-deploy
Redhat Openstack deployment 


## install RHEL-OSP5 installer

###组网说明

系统会有以下网络
   系统用到的网络硬件：
#####OSP的控制节点：
     千兆网卡1:
        网卡名：eno2
        功能：部署管理网 10.168.0.0/16
     万兆网卡1:
        网卡名称：enp32s0f0
        功能：内部管理外网（VLANID 596）192.168.52.0/24
        功能：生产外网1   （VLANID 597）192.168.53.0/24
        功能：生产外网2   （VLANID 598）192.168.54.0/24
        功能：生产外网3   （VLANID 599）192.168.55.0/24
        重要说明：这些网络是通过VLAN进行隔离的。各生产网禁止互通（业务的要求）
     控制节点必须传入的参数：
        ceph_pub_ip           连接存储公网的IP    例如 172.16.X.X   172.16.0.3
        rhosp_pub_ip          连接内部管理网的IP  例如 192.168.52.X 192.168.52.3
        controller_priv_host  连接部署管理网的IP  例如 10.168.0.X   10.168.0.3
        重要说明：这仨参数必须在您新建主机上进行覆盖传入！

   1. 云内网－－

###Step 1.
copy yum source to /var/www/html/repos
rhel-server-rhscl-6-rpms
rhel-6-server-openstack-foreman-rpms
rhel-x86_64-server-6-rhscl-1

###Step 2.
configure repositories and update system

[root@foreman repos]# cat /etc/yum.repos.d/local.repo

[rhel-x86_64-server-6]

name=rhel-x86_64-server-6

baseurl=file:///var/www/html/repos/rhel-x86_64-server-6

enabled=1

gpgcheck=0

gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release



[rhel-x86_64-server-6-rhscl-1]

name=rhel-x86_64-server-6-rhscl-1

baseurl=file:///var/www/html/repos/rhel-x86_64-server-6-rhscl-1

enabled=1

gpgcheck=0

gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[rhel-x86_64-server-6-ost-5]

name=rhel-x86_64-server-6-ost-5

baseurl=file:///var/www/html/repos/rhel-x86_64-server-6-ost-5

enabled=1

gpgcheck=0

gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release



[rhel-x86_64-server-6-ost-foreman]

name=rhel-x86_64-server-6-ost-foreman

baseurl=file:///var/www/html/repos/rhel-x86_64-server-6-ost-foreman

enabled=1

gpgcheck=0

gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release



[rhel-x86_64-server-rh-common-6]

name=rhel-x86_64-server-rh-common-6

baseurl=file:///var/www/html/repos/rhel-x86_64-server-rh-common-6

enabled=1

gpgcheck=0

gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release



[ceph-noarch-rhel6]

name=ceph-noarch-rhel6

baseurl=file:///var/www/html/repos/ceph-noarch-rhel6

enabled=1

gpgcheck=0

gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release



[ceph-rhel6]

name=ceph-rhel6

baseurl=file:///var/www/html/repos/ceph-rhel6

enabled=1

gpgcheck=0

[root@foreman yum.repos.d]# 

更新您的安装器

yum update
reboot

###Step 3: 安装并配置时间服务器

yum install ntp ntpdate
安装ntp ntpdate 包，先把自己改成NTP服务器。

vim /etc/ntp.conf

Remove or comment out all server lines

server 127.127.1.0

fudge 127.127.1.0 stratum 10

restrict 10.0.168.0 mask 255.255.255.0

重启服务并打开防火墙

service ntpd restart

chkconfig ntpd on

lokkit --port 123:up

 ntpdate -v -d -u 10.0.168.35


###Step 4: 安装Staypuft

yum install rhel-osp-installer
rhel-osp-installer

这时您将看到系统缺省安装界面

###Step 5: 安装本补丁

下载：

https://github.com/tonyli71/RHOSP-deploy/archive/master.zip

在您的根目录解压覆盖一些文件


###Step 6: 重新初始数据库

删掉数据库，运行 

/reinstall_foreman.sh 

重新初始，运行

rhel-osp-installer

第一次运行 rhel-osp-installer 一般回出以下错误，再次运行就好了

/Stage[main]/Foreman::Database/Foreman::Rake[db:seed]/Exec[foreman-rake-db:seed]: Failed to call refresh: /usr/sbin/foreman-rake db:seed returned 1 instead of one of [0]
 /Stage[main]/Foreman::Database/Foreman::Rake[db:seed]/Exec[foreman-rake-db:seed]: /usr/sbin/foreman-rake db:seed returned 1 instead of one of [0]

得到成功的输出：

Success!
  * Foreman is running at https://foremana.cmri.com
      Initial credentials are admin / JFkfwVZF6AtZs9n4
  * Foreman Proxy is running at https://foremana.cmri.com:8443
  * Puppetmaster is running at port 8140
  The full log is at /var/log/rhel-osp-installer/rhel-osp-installer.log

