#!/bin/bash -e

CURDIR="$PWD"
TMPDIR13="$CURDIR/unpack/13"
TARBALL13="$CURDIR/Xilinx_ISE_DS_Lin_13.4_O.87xd.3.0.tar"
TMPDIR9="$CURDIR/unpack/9"
TARBALL9="$CURDIR/ISE_DVD_92i.tar.gz"
HM2FW_DIR="${CURDIR}/hostmot2-firmware"
HM2FW_URL="https://github.com/LinuxCNC/hostmot2-firmware.git"
SUITE="ISE_DS"
LICENSE_FILE="${CURDIR}/Xilinx/13.4/${SUITE}/EDK/data/core_licenses/Xilinx.lic"



install-ise-13() {
    # Install Xilinx ISE 13.4
    if ! test -f "${CURDIR}/Xilinx/13.4/${SUITE}/.xinstall/install.log" || \
	    ! grep -q 'Xilinx Installer/Updater exited with return status "0"' \
	      "${CURDIR}/Xilinx/13.4/${SUITE}/.xinstall/install.log"; then

	# Unpack tarball into temp directory
	if ! test -f "${TMPDIR13}/.unpacked" && \
		! test -f "${CURDIR}/Xilinx/13.4/${SUITE}/.xinstall/install.log"; then
	    echo "Unpacking tarball:"
	    echo "    '${TARBALL13}'"
	    echo "    -> '${TMPDIR13}'"
	    mkdir -p "${TMPDIR13}"
	    tar xCf "${TMPDIR13}" "${TARBALL13}" --strip-components=1
	    touch "${TMPDIR13}/.unpacked"
	else
	    echo "Xilinx tarball already unpacked"
	fi

	# Run automated installer
	# - Original config file generated with:
	#   $ unpack/bin/lin64/batchxsetup -samplebatchscript ise-install-13.conf
	#   - Add `eula_accepted=Y` for completely automated install
	echo "Running Xilinx 13.4 installer"
	"${TMPDIR13}/bin/lin64/batchxsetup" -batch "${CURDIR}/ise-install-13.conf"
    else
	echo "Xilinx 13.4 ${SUITE} already installed"
    fi
    
    # Add license to license file
    if ! grep -q 'PACKAGE ISE_WebPACK xilinxd' "${LICENSE_FILE}"; then
	if test -f "${CURDIR}/Xilinx.lic"; then
	    echo "Adding license:"
	    echo "    from '${CURDIR}/Xilinx.lic'"
	    echo "    to '${LICENSE_FILE}'"
	    cat "${CURDIR}/Xilinx.lic" >> "${LICENSE_FILE}"
	else
	    echo "ERROR:  No license file found in ${CURDIR}/Xilinx.lic!"
	fi
    else
	echo "License already present in ${LICENSE_FILE}"
    fi
}

install-ise-9() {
    # Install Xilinx ISE 9.2
    if ! test -f "${CURDIR}/Xilinx/9.2i/.xinstall/install.log" || \
	    ! grep -q 'summary= Batch install completed' \
	      "${CURDIR}/Xilinx/9.2i/.xinstall/install.log"; then

	# Unpack tarball into temp directory
	if ! test -f "${TMPDIR9}/.unpacked" && \
		! test -f "${CURDIR}/Xilinx/9.2i/.xinstall/install.log"; then
	    echo "Unpacking tarball:"
	    echo "    '${TARBALL9}'"
	    echo "    -> '${TMPDIR9}'"
	    mkdir -p "${TMPDIR9}"
	    tar xCf "${TMPDIR9}" "${TARBALL9}" --strip-components=1
	    touch "${TMPDIR9}/.unpacked"
	else
	    echo "Xilinx tarball already unpacked"
	fi

	# Run automated installer
	# - See notes in file
	echo "Running Xilinx 9.2 installer"
	"${TMPDIR9}/bin/lin64/setup" -batch "${CURDIR}/ise-install-9.conf"
    else
	echo "Xilinx 9.2 already installed"
    fi
}

clone-hm2-fw() {
    # Clone hostmot2-firmware into current directory
    if ! test -d "${HM2FW_DIR}/.git"; then
	echo "Cloning hotmot2-firmware:"
	echo "    from ${HM2FW_URL}"
	echo "    to ${HM2FW_DIR}"
	git clone "${HM2FW_URL}" "${HM2FW_DIR}"
    else
	echo "Firmware already cloned into directory ${HM2FW_DIR}"
    fi
}


echo "Starting install on $(date)"
install-ise-13
install-ise-9
clone-hm2-fw
echo "Finished install on $(date)"
