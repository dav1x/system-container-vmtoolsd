FROM registry.access.redhat.com/rhel7.3

ENV SYSTEMD_IGNORE_CHROOT=1

RUN yum -y --disablerepo=\* --enablerepo=rhel-7-server-rpms install yum-utils && \
  yum-config-manager --disable \* && \
  yum-config-manager --enable rhel-7-server-rpms && \
  yum clean all


RUN yum -y install file open-vm-tools perl open-vm-tools-deploypkg net-tools iproute systemd && \ 
yum clean all 

LABEL Version=1.0
LABEL Vendor="Red Hat" License=GPLv3

LABEL INSTALL="docker run --rm --privileged -v /:/host -e HOST=/host -e IMAGE=IMAGE -e NAME=NAME IMAGE /usr/local/bin/vmtoolsd-install.sh"
LABEL UNINSTALL="docker run --rm --privileged -v /:/host -e HOST=/host -e IMAGE=IMAGE -e NAME=NAME IMAGE /usr/local/bin/vmtoolsd-uninstall.sh"

LABEL RUN="docker run  --privileged -v /proc/:/hostproc/ -v /sys/fs/cgroup:/sys/fs/cgroup  -v /var/log:/var/log -v /run/systemd:/run/systemd -v /sysroot:/sysroot -v=/var/lib/sss/pipes/:/var/lib/sss/pipes/:rw -v /etc/passwd:/etc/passwd -v /etc/shadow:/etc/shadow -v /tmp:/tmp:rw -v /etc/sysconfig:/etc/sysconfig:rw -v /etc/resolv.conf:/etc/resolv.conf:rw -v /etc/nsswitch.conf:/etc/nsswitch.conf:rw -v /etc/hosts:/etc/hosts:rw -v /etc/hostname:/etc/hostname:rw -v /etc/localtime:/etc/localtime:rw -v /usr/share/zoneinfo:/usr/share/zoneinfo:Z --env container=docker --net=host  --pid=host IMAGE"

ADD open-vm-tools-10.0.5-2.el7_3.2.x86_64.rpm /
RUN yum -y localinstall open-vm-tools-10.0.5-2.el7_3.2.x86_64.rpm

CMD /usr/bin/vmtoolsd

ADD service.template config.json /exports/

#ADD sssd.conf /
#ADD sss_proxy /
#ADD vmtoolsd-install.sh /usr/local/bin/vmtoolsd-install.sh
#ADD vmtoolsd-uninstall.sh /usr/local/bin/vmtoolsd-uninstall.sh
#ADD vmtools_cmd /usr/bin/
