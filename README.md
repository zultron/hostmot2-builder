# hostmot2-builder

Builds hostmot2 firmware from [LinuxCNC source][source] in a Docker container

[source]: https://github.com/LinuxCNC/hostmot2-firmware

## Usage

- Check out this repo and `cd` into it
  - `git clone https://github.com/zultron/hostmot2-builder`
  - `cd hostmot2-builder`

- Download Xilinx ISE, versions 13.4 and 9.2
  - Go to the Xilinx [downloads page][xilinx-dls]
  - Download "ISE Design Suite 13.4 Full Product Installation", "Full
    Installer For Linux (5.8 GB)"
  - Put the file in this directory, naming it
    `Xilinx_ISE_DS_Lin_13.4_O.87xd.3.0.tar`
  - Download "ISE Foundation 9.2i Full Product Installation", "All
    Platforms (2.76 GB)"
  - Put the file in this directory, naming it `ISE_DVD_92i.tar.gz`

- Obtain a license for `ISE_WebPACK`
  - Go to the Xilinx [product licensing page][xilinx-pls]
  - On the "Product Licensing" page ("Create New Licenses" tab),
	click the checkbox next to "ISE WebPACK License", click the
	"Generate Node-Locked License" button, and follow through the
	prompts
  - Get the generated license file either from your email or from the
	"Manage Licenses" tab (by selecting the license and clicking the
	"Download" down-arrow icon in the lower-left)
  - Save into `Xilinx.lic`

- Build the Docker container
  - `docker build -t hostmot2-builder docker`

- Once the above steps are complete, unpack, install and configure
  Xilinx ISE
  - `./container.sh ./doit.sh`

- Now the build environment is complete; from here, you may run
  - `./container.sh make -C hostmot2-firmware`

[xilinx-dls]: https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/design-tools/archive.html
[xilinx-pls]: https://www.xilinx.com/getlicense
