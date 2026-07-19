└───╼ $ ▶ ./tools/genkey-helper.sh
Generating signing keys in: /home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys:
  Generating secure-boot signing key (RSA-2048) ...
  Generating AVB signing key (RSA-4096) ...
  Generating AVB x509 certificate (PEM) ...
  Generating IMA/EVM private key ...
  Generating IMA/EVM x509 certificate (DER) ...
  Generating kernel module signing private key ...
  Generating kernel module signing x509 certificate (PEM) ...
  Generating SWUpdate CMS signing key (EC prime256v1) ...
  Generating SWUpdate CMS x509 certificate (PEM) ...
  Generating SWUpdate AES key file (AES-256-CBC) ...
  Generating SSH CA key pair (ed25519) ...
  Generating SSH client key pair (ed25519) ...
  Generating SSH root key pair (ed25519) ...

All keys generated successfully.

Add the following to your local.conf (or kas header):
#######################################################
RPI_SIGNING_KEYS_DIR     = "/home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys"
RPI_SECURE_BOOT_SIGN_KEY = "/home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/privkey_secure-bootsign.pem"
AVB_SIGN_KEY             = "/home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/privkey_avb.pem"
AVB_X509                 = "/home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/x509_avb.pem"
IMA_EVM_PRIVKEY          = "/home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/privkey_ima.pem"
IMA_EVM_X509             = "/home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/x509_ima.der"
MODSIGN_PRIVKEY          = "/home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/privkey_modsign.pem"
MODSIGN_X509             = "/home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/x509_modsign.pem"
SWUPDATE_CMS_KEY         = "/home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/privkey_swupdate.pem"
SWUPDATE_CMS_CERT        = "/home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/x509_swupdate.pem"
SWUPDATE_AES_FILE        = "/home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/swupdate-aes.key"
OPENSSH_CA_PUBKEY        = "/home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/ssh_ca_key.pub"
#######################################################

Generated kas fragment: /home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/kas-signing-keys.yml
Use it directly in your build:
  kas build kas-rpi-secure.yml:/home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/kas-signing-keys.yml

SSH CA private key (keep secret): /home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/ssh_ca_key

To sign the client keys with the CA:
  ssh-keygen -s /home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/ssh_ca_key -I user-rpi  -n rpi  -V +1w /home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/ssh_client.pub
  ssh-keygen -s /home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/ssh_ca_key -I user-root -n root -V +1d /home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/ssh_root.pub

To connect:
  ssh -i /home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/ssh_client rpi@<device-ip>
  ssh -i /home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/ssh_root root@<device-ip>

NOTICE: These file-based keys are not suitable for high security requirements :
For production, store private keys in a Hardware Security Module (HSM)
or TPM and use PKCS#11 URIs instead of file based keys


---
KAS_MACHINE=raspberrypi5 SECURITY_PROFILE=dev kas build kas-rpi-secure.yml:kas-signing-keys.yml
KAS_MACHINE=raspberrypi5 --runtime-args "-e SECURITY_PROFILE=dev" kas-container build kas-rpi-secure.yml:kas-signing-keys.yml


sudo bmaptool copy build/tmp/deploy/images/raspberrypi5/rpi-secure-image-base-raspberrypi5.rootfs.wic.bz2  /dev/sdX
sudo bmaptool copy build/tmp/deploy/images/raspberrypi5/rpi-secure-image-base-raspberrypi5.rootfs-dev_1.0.0-rc8-8-gd2d6bc8-dirty.wic.bz2  /dev/sdf


└───╼ (.venv) $ ▶ ssh -i /home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/ssh_client rpi@192.168.1.8

# 'rpi'  : 'notrustnofun' (non admin user)
# 'root' : '1234butbetter'

└───╼ (.venv) $ ▶ ssh -i /home/hroland/developpements/yocto-experience/a-meta-raspberrypi-secure/rpi-secure-keys/ssh_root root@192.168.1.8

https://192.168.1.8/swupdate/

