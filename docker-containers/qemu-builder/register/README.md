# binfmt_misc regiser/unregister

Register qemu-*binfmt for all supported processors except the current one

* `docker run --rm --privileged emby/qemu-builder:register`

Unregister all registered binfmt_misc:

* `docker run --rm --privileged emby/qemu-builder:register -r`
