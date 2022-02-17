#!/bin/bash

sudo dd if=/dev/zero of=/dev/nvme0n1 bs=4M count=10
sudo podman run --pull=always --privileged --rm \
  -v /dev:/dev -v /run/udev:/run/udev -v .:/data -w /data \
  quay.io/coreos/coreos-installer:release \
  install /dev/nvme0n1 -i config.ign
