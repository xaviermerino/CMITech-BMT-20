FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
      udev \
      usbutils \
      qt4-dev-tools \
      libqt4-dbg \
      libqt4-dev \
      libopencv-dev \
      libopencv-contrib-dev \
      libusb-1.0-0-dev \
      libudev-dev && \
    rm -rf /var/lib/apt/lists/*

# Download tini static binary
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-amd64 /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini

# The 'BMT20' directory here refers to the 
# 'Ubuntu18.04_Desktop_x64_EMX&BMT_SDK_V1.4.0' folder 
# included as part of the CMITech SDK package.
# For simplicity, we have renamed that SDK folder to 'BMT20'.
COPY ["BMT20", "/usr/local/CMITech/BMT20"]
COPY ["BMT20/udev.rules/80-drivers.rules", "/etc/udev/rules.d/80-drivers.rules"]
COPY ["entrypoint.sh", "/usr/local/bin/entrypoint.sh"]

RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/CMITech/BMT20/x64/bin/BMTDemo

ENTRYPOINT ["/usr/local/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]

CMD ["/usr/local/CMITech/BMT20/x64/bin/BMTDemo"]
