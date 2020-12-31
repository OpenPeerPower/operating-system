# Open Peer Power Operating-System

Open Peer Power Operating System (formerly OppOS) is an operating system optimized for hosting [Open Peer Power](https://www.openpeerpower.io) and its [Add-ons](https://www.openpeerpower.io/addons/).

Open Peer Power Operating System uses Docker as Container engine. It by default deploys the Open Peer Power Supervisor as a container. Open Peer Power Supervisor in turn uses the Docker container engine to control Open Peer Power Core and Add-Ons in separate containers. Open Peer Power Operating System is **not** based on a regular Linux distribution like Ubuntu. It is built using [buildroot](https://buildroot.org/) and it is optimized for running Open Peer Power, especially on single board compute (SBC) devices like the Pi, ODROID, NUC and Tinker Board (see supported hardware below).

## Features

- Lightweight and memory-efficient
- Minimized I/O
- Over The Air (OTA) updates
- Offline updates
- Modular using Docker

## Supported hardware

- Raspberry Pi
- Hardkernel ODROID
- Intel NUC
- Asus Tinker Board
- Virtual appliances

See the full list and specific models [here](./Documentation/boards/README.md)

## Getting Started

If you just want to use Open Peer Power the official [getting started guide](https://www.openpeerpower.io/getting-started/) and [installation instructions](https://www.openpeerpower.io/oppio/installation/) take you through how to download Open Peer Power Operating System and get it running on your machine.

If you're interested in finding out more about Open Peer Power Operating System and how it works read on...

## OppOS components

- **Bootloader:**
  - [Barebox](https://barebox.org/) for devices that support EFI
  - [U-Boot](https://www.denx.de/wiki/U-Boot) for devices that don't support EFI
- **Operating System:**
  - [Buildroot](https://buildroot.org/) LTS Linux
- **File Systems:**
  - [SquashFS](https://www.kernel.org/doc/Documentation/filesystems/squashfs.txt) for read-only file systems (using LZ4 compression)
  - [ZRAM](https://www.kernel.org/doc/Documentation/blockdev/zram.txt) for `/tmp`, `/var` and swap (using LZ4 compression)
- **Container Platform:**
  - [Docker Engine](https://docs.docker.com/engine/) for running Open Peer Power components in containers
- **Updates:**
  - [RAUC](https://rauc.io/) for Over The Air (OTA) and USB updates
- **Security:**
  - [AppArmor](https://apparmor.net/) Linux kernel security module

If you don't have experience with these, embedded systems, buildroot or the build process for Linux distributions, then please read up on these topics. The rest of the documentation in this project is for developers and assumes you have experience with embedded systems or a strong understanding of the internal workings of operating systems.

## Developer Documentation

All developer documentation is in the [Documentation](./Documentation) directory.

### Development builds

The Development build GitHub Action Workflow is a manually triggered workflow
which creates Open Peer Power OS development builds. The development builds are
available at [os-builds.openpeerpower.io](https://os-builds.openpeerpower.io/).
