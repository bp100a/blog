+++
title = "Threading with Python"
description = ""
tags = [
    "development",
]
date = "2018-11-21"
categories = [
    "Development",
]
highlight = "true"
+++

I'm working on a hobby project that uses a Raspberry Pi to control a hardware photogrammetry setup. It takes about 15 seconds to pull a picture out of the camera (a Nikon Coolpix S3300) using the gphoto2 library. It takes another 15 seconds or so to upload the picture to a google drive (the images are about 4MB). This is a great application for partitioning the work between two threads as I can double the throughput of the system.

Problem is in Python threading is pretty lame. The Global Interpreter Lock (GIL) does a good job of making sure the threads can't get into any trouble, effectively muting most of the benefits of threading. 

So even with a Raspberry Pi and 4 cores I'm stuck to an effective single execution thread when using Python. The solution is (of course) multiprocessing.

Multiple processes carry the overhead of requiring much more context communication since the memory spaces are segregated, and an effective way of communicating this context between processes is required.

Fortunately my solution already uses a queueing system, beanstalk, to provide for data exchange between the h/w control process and a REST API used by the Javascript/HTML user interface.

```python
from multiprocessing import Process

def start_drive_process():
    """Start the process that will upload photos to the
    google drive"""
    p = Process(target=google_drive.process_photos, args=())
    p.start()
```
The body of the drive process is pretty simple as well:

```python
import time
import json
import base64
import beanstalkc as beanstalk

GDRIVE_QUEUE = 'gdrive'

def configure_drive_queue() -> beanstalk.Connection:
    """set up our beanstalk queue for inter-process
    messages"""
    queue = beanstalk.Connection(host='localhost', port=14711)
    queue.watch(GDRIVE_QUEUE) # tube that'll contain cancel requests
    return queue


def wait_for_work(queue: beanstalk.Connection) -> str:
    """wait for work, return json"""
    while True:
        job = queue.reserve(timeout=0)
        if job:
            job_json = job.body
            job.delete()  # remove from the queue
            return json.loads(job_json)

        time.sleep(0.001) # sleep for 1 ms to share the computer

def process_photos():
    """This is a separate process that will
    receive photo information and upload to the
    google drive"""

    queue = configure_drive_queue()
    drive = None

    while True:
        job_dict = wait_for_work(queue)
        task = job_dict['task']

        if task == 'token':
            access_info = json.loads(job_dict['value'])
            drive = GoogleDrive(access_info)
            if drive:
                drive.create_root_folder('rpipg')
            continue

        if task == 'photo':
            decoded_bytes = base64.decodebytes(job_dict['data'].encode('utf-8'))
            drive.write_file_bytes(job_dict['filename'], decoded_bytes)
```

This creates a separate process that waits for queue entries to work on. One such queue entry is a token information, basically all the oAuth2 information needed to connect to the Google Drive API. The second type of entry is a photo, whic includes the entire image data encoded in base64 so it's palatable to the queueing software. Please note that these images are large, about 4.5MB after base64 encoding and the queue default size limit had to be greatly increased. This is fine for a device implementation but not something I'd want to do in a production environment.

The end result is that the system can effectively overlap picture capture with google drive upload, doubling throughput. 