#!/bin/bash -e

CURDIR="$PWD"
TMPDIR13="$CURDIR/unpack/13"
TARBALL13="$CURDIR/Xilinx_ISE_DS_Lin_13.4_O.87xd.3.0.tar"
TMPDIR10="$CURDIR/unpack/10"
TARBALL10="$CURDIR/ISE_DS.tar"
HM2FW_DIR="${CURDIR}/hostmot2-firmware"
HM2FW_URL="https://github.com/LinuxCNC/hostmot2-firmware.git"
SUITE="ISE_DS"
LICENSE_FILE="${CURDIR}/Xilinx/13.4/${SUITE}/EDK/data/core_licenses/Xilinx.lic"



banner() {
    echo
    echo "***********************************************************************"
    if test -n "$*"; then
	echo "***** ${*}"
	echo "***********************************************************************"
    fi
}

install-ise-13() {
    # Install Xilinx ISE 13.4
    if ! test -f "${CURDIR}/Xilinx/13.4/${SUITE}/.xinstall/install.log" || \
	    ! grep -q 'Xilinx Installer/Updater exited with return status "0"' \
	      "${CURDIR}/Xilinx/13.4/${SUITE}/.xinstall/install.log"; then

	banner "Unpack Xilinx ISE 13.4 tarball"
	if ! test -f "${TMPDIR13}/.unpacked" && \
		! test -f "${CURDIR}/Xilinx/13.4/${SUITE}/.xinstall/install.log"; then
	    echo "    Unpacking '${TARBALL13}'"
	    echo "        into '${TMPDIR13}'"
	    mkdir -p "${TMPDIR13}"
	    tar xCf "${TMPDIR13}" "${TARBALL13}" --strip-components=1
	    touch "${TMPDIR13}/.unpacked"
	else
	    echo "    Xilinx tarball already unpacked"
	fi

	banner "Running Xilinx ISE 13.4 batch install"
	# - Original config file generated with:
	#   $ unpack/bin/lin64/batchxsetup -samplebatchscript ise-install-13.conf
	#   - Add `eula_accepted=Y` for completely automated install
	"${TMPDIR13}/bin/lin64/batchxsetup" -batch "${CURDIR}/ise-install-13.conf"
    else
	banner "Unpack Xilinx ISE 13.4 tarball"
	echo "    Xilinx 13.4 ${SUITE} already installed"
    fi
    
    # Add license to license file
    banner "Add Xilinx ISE 13.4 license to license file"
    if ! grep -q 'PACKAGE ISE_WebPACK xilinxd' "${LICENSE_FILE}"; then
	if test -f "${CURDIR}/Xilinx.lic"; then
	    echo "    from '${CURDIR}/Xilinx.lic'"
	    echo "    to '${LICENSE_FILE}'"
	    cat "${CURDIR}/Xilinx.lic" >> "${LICENSE_FILE}"
	else
	    echo "ERROR:  No license file found in '${CURDIR}/Xilinx.lic'!"
	    exit 1
	fi
    else
	echo "License already present in ${LICENSE_FILE}"
    fi
}

install-ise-10() {
    # Install Xilinx ISE 10.1
    if ! test -f "${CURDIR}/Xilinx/10.1/.xinstall/install.log" || \
	    ! grep -q 'summary= Batch install completed' \
	      "${CURDIR}/Xilinx/10.1/.xinstall/install.log"; then

	banner "Unpack Xilinx ISE 10.1 tarball"
	if ! test -f "${TMPDIR10}/.unpacked" && \
		! test -f "${CURDIR}/Xilinx/10.1/.xinstall/install.log"; then
	    echo "    Unpacking '${TARBALL10}'"
	    echo "    -> '${TMPDIR10}'"
	    mkdir -p "${TMPDIR10}"
	    tar xCf "${TMPDIR10}" "${TARBALL10}" --strip-components=1
	    touch "${TMPDIR10}/.unpacked"
	else
	    echo "    Xilinx tarball already unpacked"
	fi

	banner "Running Xilinx ISE 10.1 batch install"
	# - See notes in file
	"${TMPDIR10}/bin/lin64/setup" -batch "${CURDIR}/ise-install-10.conf"
    else
	echo "    Xilinx 10.1 already installed"
    fi
}

clone-hm2-fw() {
    banner "Clone hostmot2-firmware"
    if ! test -d "${HM2FW_DIR}/.git"; then
	echo "    from ${HM2FW_URL}"
	echo "    to ${HM2FW_DIR}"
	git clone "${HM2FW_URL}" "${HM2FW_DIR}"
    else
	echo "    Firmware already cloned into directory ${HM2FW_DIR}"
    fi
}


banner "Starting install on $(date)"
banner
install-ise-13
install-ise-10
clone-hm2-fw
banner
banner "Finished install on $(date)"
