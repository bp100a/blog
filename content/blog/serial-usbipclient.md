---
author: "Harry Collins"
date: 2024-10-29
linktitle: usbip
title: Serial USBIP Client
highlight: true
---


## Direct access to a USB via TCP/IP for serial devices
Sometimes you need to "share" a USB device between different computers. There are numerous 3rd party solutions, but most rely on USBIP (USB-over-IP). This technology allows the low-level USB protocol (USB Request Blocks, aka URBs) to be exchanged between two computers using a TCP/IP connection. As both Linux & Windows have USBIP servers and Clients, devices can be shared across platforms.

Microsoft's WSL (Windows Subsystem for Linux) uses this technology to share USB devices between the host (Windows) and any Linux client running in WSL that need access to a USB device.

The problem is the sharing is "rigid", devices are mapped, and the device names cannot change, particularly if you are mapping to a docker microservice running in WSL. USB device names can change if the device performs a reset function or is unplugged. There are ways around this rigidity, but they come with their own complications and problems.

Wouldn't it be nice if your remote client could just connect directly to the USB device using the USBIP protocol? Doing this for all device classes would be extraordinarily difficult as you'd be replicating the behavior of the local usb device drivers, but it's very feasible if you only need a serial connection to the target USB device.

This is where serial-usbipclient, a pypi package I recently published comes into play. This package forms a direct connection to the USBIP server that is hosting the device, allowing for a direct connection without using the local platforms USB device stack, just a socket connection to the remote server. serial-usbipclient takes care of the USBIP protocol and allows reading/writing byte data directly to the device.
