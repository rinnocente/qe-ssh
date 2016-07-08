#
# Quantum Espresso : a program for electronic structure calculations
# ssh container version
#
#
# For many reasons we need to fix the ubuntu release:
FROM ubuntu:16.04

MAINTAINER roberto innocente <inno@sissa.it>
#
# we replace the standard http://archive.ubuntu.com repository
# that is very slow, with the new mirror method :
#     deb mirror://mirror.ubuntu.com/mirrors.txt ...
ADD  http://people.sissa.it/~inno/qe/sources.list /etc/apt/
#
# we update the package list 
# and install openssh-server, sudo, wget, update-motd 
# and run ssh-keygen -A to generate all possible keys for the host
RUN apt update && apt install -y openssh-server sudo wget update-motd && ssh-keygen -A   
#
# we create the user 'qe' and add it to the list of sudoers
RUN  adduser -q --disabled-password --gecos qe qe
RUN  echo "qe 	ALL=(ALL:ALL) ALL" >>/etc/sudoers
#
# we add /home/qe to the PATH of user 'qe'
RUN echo "export PATH=/home/qe:${PATH}" >>/home/qe/.bashrc
#
# we move to /home/qe
WORKDIR /home/qe
#
# we copy the 'qe' files and the needed shared libraries to /home/qe
# then we unpack them : the 'qe' directly there, the shared libs
# from /
RUN wget  http://people.sissa.it/~inno/qe/qe.tgz http://people.sissa.it/~inno/qe/sl-02.tgz && tar xvzf qe.tgz && tar xvzf sl-02.tgz -C /
#
# we remove the archives we copied
RUN  rm qe.tgz sl-02.tgz 

#
# we copy an ascii art in the new motd way
RUN  wget http://people.sissa.it/~inno/qe/qe-logo.ascii && cp qe-logo.ascii /etc/update-motd.d/15-qe && chmod a+rx /etc/update-motd.d/15-qe && /usr/sbin/update-motd

#
# we remove remnants, chown to files in /home/qe, make pw.x executable, set 'qe' passwd
RUN rm qe-logo.ascii && chown -R qe:qe /home/qe  && chmod a+x pw.x && (echo "qe:mammamia"|chpasswd)

RUN service   ssh  restart 

EXPOSE 22

#
# the container now be reached via ssh
CMD [ "/usr/sbin/sshd","-D" ]


