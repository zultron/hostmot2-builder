#!/bin/bash -xe

CURDIR="$PWD"
TMPDIR="$CURDIR/unpack"
TARBALL="$CURDIR/Xilinx_ISE_DS_Lin_13.4_O.87xd.3.0.tar"
HM2FW_DIR="${CURDIR}/hostmot2-firmware"
HM2FW_URL="https://github.com/LinuxCNC/hostmot2-firmware.git"
LICENSE_FILE="${CURDIR}/Xilinx/13.4/ISE_DS/EDK/data/core_licenses/Xilinx.lic"

doit() {
    # Unpack Xilinx ISE into temp directory
    mkdir -p "${TMPDIR}"
    if ! test -f "${TMPDIR}/.unpacked"; then
	tar xCf "${TMPDIR}" "${TARBALL}" --strip-components=1
	touch "${TMPDIR}/.unpacked"
    else
	echo "Xilinx tarball already unpacked"
    fi

    # Run automated installer
    if ! grep -q 'Xilinx Installer/Updater exited with return status "0"' \
	 "${CURDIR}/Xilinx/13.4/SDK/.xinstall/install.log"; then
	"${TMPDIR}/bin/lin64/batchxsetup" -batch "${CURDIR}/ise-install.conf"
    else
	echo "Xilinx 13.4 SDK already installed"
    fi
    
    # Add license to license file
    if ! grep -q 'PACKAGE ISE_WebPACK xilinxd' "${LICENSE_FILE}"; then
	if test -f "${CURDIR}/Xilinx.lic"; then
	    cat "${CURDIR}/Xilinx.lic" >> "${LICENSE_FILE}"
	else
	    print "ERROR:  No license file found in ${CURDIR}/Xilinx.lic!"
	fi
    else
	echo "License already present in ${LICENSE_FILE}"
    fi

    # Clone hostmot2-firmware into current directory
    if ! test -d "${HM2FW_DIR}/.git"; then
	git clone "${HM2FW_URL}" "${HM2FW_DIR}"
    else
	echo "Firmware already cloned into directory ${HM2FW_DIR}"
    fi

    # # Clean up
    # cd $CURDIR
    # rm -r $TMPDIR
}


doit
