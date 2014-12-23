FROM ubuntu:14.04
 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8

#Runit
RUN apt-get install -y runit 
CMD /usr/sbin/runsvdir-start

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common

RUN apt-get install -y python-dev libsqlite3-dev libxml2-dev libxslt1-dev libffi-dev libssl-dev
RUN apt-get install -y python-pip
RUN pip install requests
RUN easy_install virtualenv
RUN virtualenv myenv && \
    . /myenv/bin/activate
ENV VIRTUAL_ENV /myenv

RUN git clone --depth 1 https://github.com/openstack/barbican.git
#hack to avoid test and startup
RUN sed -i '103,105d' /barbican/bin/barbican.sh
RUN cd barbican && \
    ./bin/barbican.sh install

#Add runit services
ADD sv /etc/service 
