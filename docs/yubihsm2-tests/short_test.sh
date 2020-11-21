#!/bin/bash

# set -e

export YUBIHSM_PKCS11_CONF=./yubihsm_pkcs11.conf
export YUBIHSM_PKCS11_DBG=true
TEST_AUTH_KEY=1
TEST_AUTH_PW=password
TEST_SIGN_KEY=0004

echo 'connector = http://127.0.0.1:12345' > ${YUBIHSM_PKCS11_CONF}
echo 'debug' >>  ${YUBIHSM_PKCS11_CONF}
echo 'dinout' >>  ${YUBIHSM_PKCS11_CONF}
echo 'libdebug' >>  ${YUBIHSM_PKCS11_CONF}
echo 'debug-file = ./debug_out' >>  ${YUBIHSM_PKCS11_CONF}

yubihsm-shell                                                                 \
  --action=list-objects                                                       \
  --domains=0                                                                 \
  --object-type=any                                                           \
  --algorithm=any                                                             \
  --authkey="${TEST_AUTH_KEY}"                                                \
  --password="${TEST_AUTH_PW}"

openssl req                                                                   \
  -new                                                                        \
  -x509                                                                       \
  -days 9125                                                                  \
  -nodes                                                                      \
  -config ./openssl.cnf                                                       \
  -extensions v3_ca                                                           \
  -engine pkcs11                                                              \
  -key "${TEST_AUTH_KEY}:${TEST_SIGN_KEY}"                                    \
  -keyform engine                                                             \
  -out ./hsm-root-ca-01.dum.my.crt.pem

openssl req                                                                   \
  -new                                                                        \
  -x509                                                                       \
  -days 9125                                                                  \
  -nodes                                                                      \
  -config ./openssl.cnf                                                       \
  -extensions v3_ca                                                           \
  -engine pkcs11                                                              \
  -key "000${TEST_AUTH_KEY}:${TEST_SIGN_KEY}"                                 \
  -keyform engine                                                             \
  -out ./hsm-root-ca-01.dum.my.crt.pem

openssl req                                                                   \
  -new                                                                        \
  -x509                                                                       \
  -days 9125                                                                  \
  -nodes                                                                      \
  -config ./openssl.cnf                                                       \
  -extensions v3_ca                                                           \
  -engine pkcs11                                                              \
  -key "slot_0-id_${TEST_SIGN_KEY}"                                           \
  -keyform engine                                                             \
  -out ./hsm-root-ca-01.dum.my.crt.pem


wc -l ./debug_out






