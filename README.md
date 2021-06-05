# Attaching

## SSL / TLS

### Recommended


### UNSAFE: Ignore the certificate
```sh
# Dangerous! This will do no certificate validation
xpra attach ssl://127.0.0.1:9876 --ssl-server-verify-mode=none   --ssl-protocol=TLSv1_2  --start-child=gnome-terminal
```

### Slightly better: Ignore host name validation
```sh
# Copy the cert file from the containers stdout into xpracert.pem
xpra attach ssl://127.0.0.1:9876 --ssl-ca-certs=./xpracert.pem --ssl-check-hostname=no --ssl-protocol=TLSv1_2  --start-child=gnome-terminal 
```

TODO:
- Pass hostname on start
- USe the  hexlify https://github.com/Xpra-org/xpra/blob/master/docs/Network/SSL.md

## Starting

Use `xpra control :10 start-child xterm` to start e.g. xterm or use the launcher 'start' in the GUI.

# ~ -- home directory

## Setup the home directory

The home directory gets mounted as a volume in `/home/user`.

The source directory is contains an [fscrypt](https://github.com/google/fscrypt) folder named `protected`.

In order to create the structure do the following  *on the host*

1. Create `home` 
2. Add basics (`.profile`,...)

Dot the follwoing *inside the container* (this is a one time job):

1. `mkdir protected`
2. `fscrypt setup ~`
3. `fscrypt encrypt ~/protected --source=custom_passphrase  --name="Super Secret"`

## Mounting home

In order to use fscrpyt the filesystem *on the host* needs to have the ~encrypt~ feature set.

### On the host

If the `home` folder is located in the `dm-1` filesystem *one the host*, then encryption needs to be enabled.

```sh
sudo tune2fs -O encrypt /dev/dm-1 # on the host
``` 

### In the container

**CAVE: This will also decrypt the folder on the host!**

To *unlock* the  `protected` folder:

```sh
fscrypt unlock protected
```

To *lock* the  `protected` folder:

```sh
fscrypt lock protected
```




# SSL (TLS)
This container is only reachable via TLS 1.2.

The container uses the following certificates to protect TLS:

```sh
CERT_STORAGE=/run/xpra/pki
CERT_FILE=${CERT_STORAGE}/cert.pem
KEY_FILE=${CERT_STORAGE}/key.pem
```

The easiest way to provide them is to mount a volume there.  If this is not done, then a self signed certificate is generated.
