# hostmot2-builder

Builds hostmot2 firmware from [LinuxCNC source][source]

[source]: https://github.com/LinuxCNC/hostmot2-firmware

## Usage

- Check out this repo and `cd` into it
- On the [Xilinx downloads page][xilinx-dls], download "ISE Foundation
  9.2i Full Product Installation" into this directory, naming the file
  `ISE_DVD_92i.tar.gz`
- `docker build -t hostmot2-builder docker`

[xilinx-dls]: https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/design-tools/archive.html
