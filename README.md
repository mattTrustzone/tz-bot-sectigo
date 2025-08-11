tz-bot
===========

This repository contains a wrapper script that makes it easier to use 
Electronic Frontier Foundation's (EFF's) Certbot with the TRUSTZONE's ACME Pro Sectigo DV server.
This wrapper is a fork of ZEROSSL's zerossl-bot

Installation
------------

Install the tz-bot script
   1. Quick: 
      1. run:
      `bash <(wget -q -O - https://github.com/mattTrustzone/tz-bot/raw/master/get-tzbot.sh)`
      2. Done!
   2. Careful: 
      1. Run: 
      `wget -q -O - https://github.com/mattTrustzone/tz-bot/raw/master/get-tzbot.sh > get-tzbot.sh`
      2. Inspect the file to see that it does what it is supposed to do
      3. Run: `source get-tzbot.sh`
   3. Download via portal:
      1. A zipped tar file of tz-bot can be downloaded in your TRUSTZONE customer portal
      2. Unzip and copy the tz-bot folder to your desired endpoint.
      3. Run `source get-tzbot.sh`
      
Usage
-----

To use the TrustZone ACME server instead of running `certbot` run `tz-bot`.
When prompted, provide your EAB KID (KeyID) and EAB HMAC Key (ACME MAC).

### Examples

```bash
sudo tz-bot certonly --standalone -d mydomain.example.com
```

```bash
sudo tz-bot --apache -d myotherdomain.example.com
```

```bash
sudo tz-bot --apache -d mythirddomain.example.com 
```

```bash
sudo tz-bot certonly --dns-cloudflare --dns-cloudflare-credentials /root/.secrets/cloudflare-api-token \
                          --dns-cloudflare-propagation-seconds 60 -d fourth.example.com \
```

Recommendations
----

Ensure correct ACME server URL is used (--server flag):

```
 --server https://emea.acme.atlas.globalsign.com/directory
```


Known issues
-----

There have been issues reported with certbot interactive prompt causing certificates of Let's Encrypt instead of GlobalSign being issued. It is recommended to hand over parameters directly using the documented flags.
