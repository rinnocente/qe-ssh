# qe-ssh
Dockerfile for a Quantum Espresso container reachable through ssh.

*(The resulting image is based on ubuntu:16.04 and its size is around ~250 MB, therefore when you pull it or run for the first time it will take some time depending on your internet connection)*

**Quantum Espresso** is a widely used package for electronic structure calculations.

Further information is  available on its website : [www.quantum-espresso.org](http://www.quantum-espresso.org/).

This Dockerfile builds a container for **QE** that is reachable trough ssh.

The image [rinnocente/qe-ssh](https://hub.docker.com/r/rinnocente/qe-ssh/) on dockerhub.com is created from this Dockerfile using :
```
  $ docker build -t qe-ssh .
```
You can run the container in background  with :
```
  $ CONT_ID=`docker run -P -d -t qe-ssh`
```
in this way (-P) the std ssh port (=22) is mapped on a free port of the host.
We can access the container discovering the port of the host on which the container ssh service is mapped :
```
  $ PORT=`docker port $CONT_ID 22|sed -e 's#.*:##'`
  $ ssh -p $PORT qe@127.0.0.1
```
the initial password for the 'qe' user is 'mammamia', don't forget to change it immediately.

The **QE** container has the QuantumEspresso executable (**pw.x**) , an input test file (**relax.in**)
and 2 pseudopotential files necessary to run the test (**C.pz-rrkjus.UPF** and **O.pz-rrkjus.UPF**) inside
the 'qe' home directory.

When you are inside the container you can run the test typing simply :
```
  $ pw.x <relax.in
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
### NB. this container can be reached via ssh through **your host port $PORT** eventually from the Internet at large.

---

### The remaining binaries of the **QuantumEspresso** suite

The complete set of binaries of the **QuantumEspresso** suite is large.
There are 63 binaries, for an uncompressed total of ~360 MB.
Therefore in the container there is only 1 test binary and 3 input files for a rapid test,
otherwise the image would be over 0.5 GB.
An easy download menu is provided that can
download one binary at a time or all of them (but compressed ~ 130 MB).
As you would expect, because it lives  in a docker container, this program is written in **golang**,
and can be started typing :
```
$ dlmenu
```
Choosing ```a``` will download all binaries in the ```bin``` subdir.
Choosing a number will download the respective binary in the ```bin``` subdir.
Choosing ```q``` wil quit the downloader.


![qe](http://www.quantum-espresso.org/wp-content/uploads/2011/12/Quantum_espresso_logo.jpg)

