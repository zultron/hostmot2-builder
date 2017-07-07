#!/bin/bash -e

CURDIR="$PWD"
TMPDIR="$CURDIR/unpack"
TARBALL="$CURDIR/Xilinx_ISE_DS_Lin_13.4_O.87xd.3.0.tar"
HM2FW_DIR="${CURDIR}/hostmot2-firmware"
HM2FW_URL="https://github.com/LinuxCNC/hostmot2-firmware.git"
SUITE="ISE_DS"
LICENSE_FILE="${CURDIR}/Xilinx/13.4/${SUITE}/EDK/data/core_licenses/Xilinx.lic"



doit() {
    # Install Xilinx ISE 13.4
    if ! test -f "${CURDIR}/Xilinx/13.4/${SUITE}/.xinstall/install.log" || \
	    ! grep -q 'Xilinx Installer/Updater exited with return status "0"' \
	      "${CURDIR}/Xilinx/13.4/${SUITE}/.xinstall/install.log"; then

	# Unpack tarball into temp directory
	if ! test -f "${TMPDIR}/.unpacked" && \
		! test -f "${CURDIR}/Xilinx/13.4/${SUITE}/.xinstall/install.log"; then
	    echo "Unpacking tarball:"
	    echo "    '${TARBALL}'"
	    echo "    -> '${TMPDIR}'"
	    mkdir -p "${TMPDIR}"
	    tar xCf "${TMPDIR}" "${TARBALL}" --strip-components=1
	    touch "${TMPDIR}/.unpacked"
	else
	    echo "Xilinx tarball already unpacked"
	fi

	# Run automated installer
	# - Original config file generated with:
	#   $ unpack/bin/lin64/batchxsetup -samplebatchscript ise-install.conf
	#   - Add `eula_accepted=Y` for completely automated install
	echo "Running Xilinx 13.4 installer"
	"${TMPDIR}/bin/lin64/batchxsetup" -batch "${CURDIR}/ise-install.conf"
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

    # Clone hostmot2-firmware into current directory
    if ! test -d "${HM2FW_DIR}/.git"; then
	echo "Cloning hotmot2-firmware:"
	echo "    from ${HM2FW_URL}"
	echo "    to ${HM2FW_DIR}"
	git clone "${HM2FW_URL}" "${HM2FW_DIR}"
    else
	echo "Firmware already cloned into directory ${HM2FW_DIR}"
    fi

    # # Clean up
    # rm -r "${TMPDIR}"

    echo "Done"
}


doit
