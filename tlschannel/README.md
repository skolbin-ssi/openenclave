TLS-Channel
===========

This sample shows how to create a client-server application that uses an
attested TLS channel. The steps are as follows.

(1) Create attested credentials by running the gencreds tool, which
    creates two files: a certificate (DER) and a private key (PEM).

(2) Runs the server program which waits for client connections. This program
    is an enclave application.

(3) Runs the client program, whose command-line arguments include the files
    generated by the gencreds tool above. This program is an ordinary Linux
    application (which will eventually run within SGX-LKL).

Writing credential files to the untrusted system of course is not secure, but
remember that the gencreds tool and the client will eventually run inside
SGX-LKL where the credential files will be written to an enclave-resident file
system (under /var/run).

To build and run this sample type:

```
make run
```