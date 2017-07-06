# hostmot2-builder

Builds hostmot2 firmware from [LinuxCNC source][source]

[source]: https://github.com/LinuxCNC/hostmot2-firmware

## Usage

- Check out this repo and `cd` into it
- On the [Xilinx downloads page][xilinx-dls], download "ISE Design
  Suite 13.4 Full Product Installation", "Full Installer For Linux
  ( - 5.8 GB)" into this directory, naming the file
  `Xilinx_ISE_DS_Lin_13.4_O.87xd.3.0.tar`
- `docker build -t hostmot2-builder docker`
- `./container.sh`
- `./doit.sh`

[xilinx-dls]: https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/design-tools/archive.html

## Licensing

- Go to the Xilinx Product Licensing Site [web site][xilinx-pls]
- Register user ID
- Fill out requested information
- On the "Product Licensing" page ("Create New Licenses" tab),
  click the checkbox next to "ISE WebPACK License", click the
  "Generate Node-Locked License" button, and follow through the
  prompts
- Get the generated license file either from your email or from the
  "Manage Licenses" tab (by selecting the license and clicking the
  "Download" down-arrow icon in the lower-left)
- Save into `Xilinx.lic`


[xilinx-pls]: https://www.xilinx.com/getlicense

FIXME unneeded?
[xilinx-lsc]: https://www.xilinx.com/support/licensing_solution_center.html


## Notes

- Automated install
  - The base script was generated with `unpack/bin/lin64/batchxsetup
    -samplebatchscript ise-install.conf`
  - Script modifications:
    - Change `copy_preferences=N`
	- Add `eula_accepted=Y`
	- Comment out "ISE Design Suite" section, uncomment "Software
      Development Kit", and change `package=...::1`
