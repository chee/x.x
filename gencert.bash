#!/bin/bash
root="$HOME/x.x"
xx="$root/x.x"
echo "type word three times, then press return 16 times, then type word again"
openssl genrsa -des3 -out "$root/ca.key" 2048
openssl req -x509 -new -nodes -key "$root/ca.key" -sha256 -days 1825 -out "$root/ca.pem"
openssl genrsa -out "$xx.key" 2048

# Generate a Certificate Signing Request (CSR) based on that private key
openssl req -new -key "$xx.key" -out "$xx.csr"

# Create a configuration-file
>"$xx.conf" cat <<OK
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.x.x
OK

# Create the certificate for the webserver to serve
openssl x509 -req -in "$xx.csr" -CA "$root/ca.pem" -CAkey "$root/ca.key" -CAcreateserial \
  -out "$xx.crt" -days 222 -sha256 -extfile "$xx.conf"

echo "import to system, double click internet widgits pty ltd and set >trust to Always Trust"
open -a "Keychain Access" "$root/ca.pem"
