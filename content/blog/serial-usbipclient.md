---
author: "Harry Collins"
date: 2024-10-29
linktitle: usbip
title: Serial USBIP Client
highlight: true
---


## Direct access to a USB via TCP/IP for serial devices
|                                               |                                                              |
|:---------------------------------------------:|:------------------------------------------------------------:|
| ![tests](/img/serial-usbipclient.svg "tests") | ![coverage](/img/serial-usbipclient-coverage.svg "coverage") |
|                                               |                                                              |

Sometimes you need to "share" a USB device between different computers. There are numerous 3rd party solutions, but most rely on USBIP (USB-over-IP). This technology allows the low-level USB protocol (USB Request Blocks, aka URBs) to be exchanged between two computers using a TCP/IP connection. As both Linux & Windows have USBIP servers and Clients, devices can be shared across platforms.

Microsoft's WSL (Windows Subsystem for Linux) uses this technology to share USB devices between the host (Windows) and any Linux client running in WSL that need access to a USB device.

The problem is the sharing is "rigid", devices are mapped, and the device names cannot change, particularly if you are mapping to a docker microservice running in WSL. USB device names can change if the device performs a reset function or is unplugged. There are ways around this rigidity, but they come with their own complications and problems.

Wouldn't it be nice if your remote client could just connect directly to the USB device using the USBIP protocol? Doing this for all device classes would be extraordinarily difficult as you'd be replicating the behavior of the local usb device drivers, but it's very feasible if you only need a serial connection to the target USB device.

This is where [serial-usbipclient](https://www.pypi.org/project/serial-usbipclient), a pypi package I recently published comes into play. This package forms a direct connection to the USBIP server that is hosting the device, allowing for a direct connection without using the local platforms USB device stack, just a socket connection to the remote server. serial-usbipclient takes care of the USBIP protocol and allows reading/writing byte data directly to the device.

Below is a snippet of code showing how to use **serial-usbipclient** to connect to a serial USB device hosted on a remote USBIP server.
Check out the [project](https://github.com/bp100a/serial-usbipclient) on github for details.

```python
from serial_usbipclient.usbip_client import USBIPClient, HardwareID, USBIP_Connection

host: str = 'localhost'
port: int = 3240  # commonly used port for USBIPD servers
target: HardwareID = HardwareID(vid=1234, pid=5678)  # USB devices are identified by VID/PID
client: USBIPClient = USBIPClient(remote=(host, port))
client.connect_server()
client.attach(devices=[target])
connections: list[USBIP_Connection] = client.get_connection(device=target)

# using the established connection, data can be written to the USB device
# using the sendall() method
connections[0].sendall(data=b'\01\02\03\04')

# response data can be read either explicitly by specifying the size of the expected
# response, or if 0 size is specified, up to a delimiter. The delimiter is a property of
# the connection and can be set, default=b'\r\n'
connections[0].delimiter = b'\n'
response: bytes = connections[0].response_data(size=0)  # reads until delimiter
```
