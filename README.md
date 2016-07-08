# qe-ssh
Dockerfile for a Quantum Espresso container reachable trough ssh

**Quantum Espresso** is a widely used package for electronic structure calculations.

This Dockerfile builds a container for **QE** that is reachable trough ssh.

The image rinnocente/qe-ssh on dockerhub.com is created from this Dockerfile using :
```
  $ docker build -t qe-ssh .
```
You can run the container in background  with :
```
  $ CONT_ID=`docker run -P -d -t qe-ssh`
```
and access it with :
```
  $ PORT=`docker port $CONT_ID|sed -e 's#.*:##'`
  $ ssh -p $PORT qe@127.0.0.1
```
the initial password for the 'qe' user is 'mammamia', don't forget to change it immediately.

The **QE** container has the QuantumEspresso executable (**pw.x**) , an input test file (**relax.in**)
and 2 pseudopotential files necessary to run the test (**C.pz-rrkjus.UPF** and **O.pz-rrkjus.UPF**) inside
the 'qe' home directory.

When you are inside the container you can run the test typing simply :
```
  $ pw.x <result.in
```

The normal way in which you use this container is sharing an input-output directory between your host 
and the container. In this case you create a subdir in your host :
```
  $ mkdir ~/qe-in-out
```
and when you run the container you share this directory  with the container as a volume :
```
 $ CONT_ID=`docker run -v ~/qe-in-out:/home/qe/qe-in-out -P -d -t qe-ssh`
 $ PORT=`docker port $CONT_ID|sed -e 's#.*:##'`
 $ ssh -p $PORT qe@127.0.0.1
```
### NB. this container can be reached via ssh trough **your host $PORT** eventually from the Internet at large.

![qe](http://www.quantum-espresso.org/wp-content/uploads/2011/12/Quantum_espresso_logo.jpg)

