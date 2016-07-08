# qe-ssh
dockerfile for a Quantum Espresso container reachable trough ssh

**Quantum Espresso** is a widely used package for electronic structure calculations.

This Dockerfile builds a container for **QE** that is reachable trough ssh.

The image rinnocente/qe-ssh on dockerhub.com is created from this Dockerfile using :
  $ docker build -t qe-ssh .

You can run the container in background  with :
```
  $ CONT_ID=`docker run -P -d -t qe-ssh`
  $ PORT=`docker port $CONT_ID|sed -e 's#.*:##'`
```
and access it with :
```
  $ ssh -p $PORT qe@127.0.0.1
```
the initial password for the 'qe' user is 'mammamia',
don't forget to change it immediately.
![qe](http://www.quantum-espresso.org/wp-content/uploads/2011/12/Quantum_espresso_logo.jpg)

