# CMITech BMT-20 SDK Docker Container

This repository contains a Docker setup for running the CMITech BMT-20 SDK, including the `BMTDemo` executable, with USB device access and X11 forwarding enabled.

## 🐳 Running the BMT Demo Container

### Prerequisites

- You must be part of the `sudoers` group or run Docker commands with `sudo`.  
- Your host system must have X11 running (`DISPLAY` environment set) for GUI forwarding.  
- USB devices matching the SDK’s vendor/product IDs will be accessible inside the container.

### ⚒️ Build the Docker Image

From the directory containing the `Dockerfile`, the `BMT20` SDK folder, and `entrypoint.sh`, run:

> Note: The directory named BMT20 is the SDK folder originally named Ubuntu18.04_Desktop_x64_EMX&BMT_SDK_V1.4.0. Renamed for simplicity. It should be included in the root of the project.


```bash
docker build -t cmit-bmt-sdk .
```

### ⬇️ Downloading the Docker Image

Alternatively, download the docker image.
```bash
docker pull ghcr.io/xaviermerino/cmit-bmt-sdk:latest
docker tag ghcr.io/xaviermerino/cmit-bmt-sdk:latest cmit-bmt-sdk
```

## 🏃 Run the Container

The container will automatically launch the `BMTDemo` application upon startup.

Example command with USB device access, X11 forwarding, and mounting an images directory to save iris captures:

```bash
xhost +local:docker
docker run -it \
  --privileged \
  --device=/dev/bus/usb \
  --shm-size=512m \
  --ipc=host \
  -e DISPLAY=$DISPLAY \
  -e XAUTHORITY=/tmp/.Xauthority \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $HOME/.Xauthority:/tmp/.Xauthority:ro \
  -v $HOME/Pictures:/Images \
  cmit-bmt-sdk
```

| Option                                     | Description                                             | Notes                                 |
| ------------------------------------------ | ------------------------------------------------------- | ------------------------------------- |
| `--privileged`                             | Grants the container extended privileges for USB access | Required for USB device access        |
| `--device=/dev/bus/usb`                    | Exposes all USB devices to the container                | Enables udev rules to work            |
| `--shm-size=512m`                          | Enlarges shared memory for X11 MIT-SHM extension        | Prevents graphics errors              |
| `--ipc=host`                               | Shares host IPC namespace for shared memory segments    | Required for MIT-SHM to work          |
| `-e DISPLAY=$DISPLAY`                      | Passes your host’s display environment variable         | Enables GUI forwarding                |
| `-e XAUTHORITY=/tmp/.Xauthority`           | Provides X11 authentication cookie                      | Mount host `.Xauthority` as read-only |
| `-v /tmp/.X11-unix:/tmp/.X11-unix`         | Mounts X11 socket for GUI forwarding                    | Enables GUI forwarding                |
| `-v $HOME/.Xauthority:/tmp/.Xauthority:ro` | Share X authority file for secure X authentication      | Read-only mount                       |
| `-v $HOME/Pictures:/Images`                | Mount directory into the container to save iris images         | Adjust as needed         |


## 🛠️ Customizing and Debugging

* To enter the container shell instead of running `BMTDemo`, override the command:

  ```bash
  docker run -it \
    --privileged \
    --device=/dev/bus/usb \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    cmit-bmt-sdk bash
  ```

* To check USB device visibility:

  ```bash
  lsusb
  ```

  You should be able to see `Bus 001 Device 014: ID 24c4:c001` listed in the entries.
---

## 📝 Notes

* If GUI apps report `Authorization required` errors, run `xhost +local:docker` on the host to allow container connections to the X server. Once done, you may remove the permissions with `xhost -local:docker`.
* For MIT-SHM X11 errors, ensure you run the container with `--shm-size` and `--ipc=host`.
* USB device permissions and access depend on running the container with `--privileged` or appropriate device permissions.
* If you want to customize the default command or add more environment variables, you can modify the `Dockerfile` or run the container with different overrides.
