#
# Quantum Espresso : a program for electronic structure calculations
#    ssh version
#
#
# For many reasons we need to fix the ubuntu release:
FROM ubuntu:16.04
#
MAINTAINER roberto innocente <inno@sissa.it>
#
# The ARG directive is a new dockerfile directive (https://github.com/docker/docker/issues/14634).
# It permits to define, differently from ENV, variables to be used only during the build and not in operations.
# If it is not supported by your docker version then the "DEBIAN_FRONTEND=noninteractive" definition
# should be placed in front of every apt install to silence the scaring warning messages
# apt  would produce
#
ARG DEBIAN_FRONTEND=noninteractive
#
# we replace the standard http://archive.ubuntu.com repository
# that is very slow, with the new mirror method :
# deb mirror://mirror.ubuntu.com/mirrors.txt ...
ADD  http://people.sissa.it/~inno/qe/sources.list /etc/apt/
#
# we update the package list 
# and install openssh-server, sudo, wget, update-motd 
# and run ssh-keygen -A to generate all possible keys for the host
RUN apt update \
	&& apt install -y openssh-server sudo wget \
	&& ssh-keygen -A   
#
# we create the user 'qe' and add it to the list of sudoers
RUN  adduser -q --disabled-password --gecos qe qe \
	&& echo "qe 	ALL=(ALL:ALL) ALL" >>/etc/sudoers
#
# we add /home/qe to the PATH of user 'qe'
RUN echo "export PATH=/home/qe/bin:${PATH}" >>/home/qe/.bashrc
#
# we move to /home/qe
WORKDIR /home/qe
#
# we copy the 'qe' files and the needed shared libraries to /home/qe
# then we unpack them : the 'qe' directly there, the shared libs
# from /
RUN wget  http://people.sissa.it/~inno/qe/qe.tgz \
	  http://people.sissa.it/~inno/qe/sl-02.tgz \
	  http://people.sissa.it/~inno/qe/bin/dlmenu \
	&& mkdir ./bin  \
	&& chmod a+x dlmenu \
	&& mv dlmenu ./bin/ \
	&& tar xzf qe.tgz \
	&& tar xzf sl-02.tgz -C /
#
# we remove the archives we copied
RUN  rm qe.tgz \
 	sl-02.tgz 
#
#
# we chown -R the files in /home/qe, make pw.x executable, set 'qe' passwd
RUN chown -R qe:qe /home/qe   \
	&& chmod a+x pw.x && (echo "qe:mammamia"|chpasswd)

RUN service   ssh  restart 

EXPOSE 22

#
# the container can be now reached via ssh
CMD [ "/usr/sbin/sshd","-D" ]


