# Cloudflared

[![Build Status](https://travis-ci.org/mdavis332/dockerfile-cloudflared.svg?branch=master)](https://travis-ci.org/mdavis332/dockerfile-cloudflared)
[![](https://images.microbadger.com/badges/image/mdavis332/cloudflared:amd64.svg)](https://microbadger.com/images/mdavis332/cloudflared:amd64)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Docker Pulls](https://img.shields.io/docker/pulls/mdavis332/cloudflared.svg)](https://hub.docker.com/r/mdavis332/cloudflared/)

a docker container which runs the [cloudflared](https://developers.cloudflare.com/1.1.1.1/dns-over-https/cloudflared-proxy/) proxy-dns at port 54 based on alpine with some parameters to enable DNS over HTTPS proxy for [pi-hole](https://pi-hole.net/) based on tutorials from [Oliver Hough](https://oliverhough.cloud/blog/configure-pihole-with-dns-over-https/) and [Scott Helme](https://scotthelme.co.uk/securing-dns-across-all-of-my-devices-with-pihole-dns-over-https-1-1-1-1/)

## run

```docker run --name cloudflared --rm --net host mdavis332/cloudflared```

### custom upstream DNS

```docker run --name cloudflared --rm --net host -e DNS1=https://9.9.9.9/dns-query -e DNS2=https://9.9.9.10/dns-query mdavis332/cloudflared```

## test

I wrote some tests in a goss.yaml file which can be executed by [dgoss](https://github.com/aelsabbahy/goss/tree/master/extras/dgoss)

```
$ dgoss run --name cloudflared --rm -ti mdavis332/cloudflared:latest
INFO: Starting docker container
INFO: Container ID: e5bd35d3
INFO: Sleeping for 0.2
INFO: Running Tests
Process: cloudflared: running: matches expectation: [true]
Package: ca-certificates: installed: matches expectation: [true]
Command: cloudflared --version | head -1: exit-status: matches expectation: [0]
Command: cloudflared --version | head -1: stdout: matches expectation: [cloudflared version DEV (built unknown)]


Total Duration: 0.028s
Count: 4, Failed: 0, Skipped: 0
INFO: Deleting container
```

## License
Distributed under the MIT license
