#!/bin/bash -e

CURDIR="$PWD"
HM2FW_DIR="${CURDIR}/hostmot2-firmware"
HM2FW_URL="https://github.com/LinuxCNC/hostmot2-firmware.git"
TMPDIR_BASE="${CURDIR}/tmp"



banner() {
    test "$1" = "-1" && { TOP=true; shift; } || TOP=false
    echo
    if $TOP; then
	echo "***********************************************************************"
	echo "***********************************************************************"
    else
	echo "-----------------------------------------------------------------------"
    fi
    if test -n "$*"; then
	echo "***** ${*}"
	if $TOP; then
	    echo "***********************************************************************"
	    echo "***********************************************************************"
	else
	    echo "-----------------------------------------------------------------------"
	fi
    fi
}

install-ise() {
    # Install Xilinx ISE
    VER=$1
    TMPDIR="${TMPDIR_BASE}/${VER}"
    case $VER in
	13.4)
	    SUITE=ISE_DS
	    SUCCESS_RE='Xilinx Installer/Updater exited with return status "0"'
	    TARBALL="${TMPDIR_BASE}/Xilinx_ISE_DS_Lin_13.4_O.87xd.3.0.tar"
	    SETUP="${TMPDIR}/bin/lin64/batchxsetup"
	    ADD_LICENSE=true
	    PATCH_UPDATE=false
	    INSTALL_LOG="${CURDIR}/Xilinx/${VER}/${SUITE}/.xinstall/install.log"
	    LICENSE_FILE="${CURDIR}/Xilinx/13.4/${SUITE}/EDK/data/core_licenses/Xilinx.lic"
	    ;;
	10.1)
	    SUITE=ISE
	    SUCCESS_RE='summary= Batch install completed'
	    TARBALL="${TMPDIR_BASE}/ISE_DS.tar"
	    SETUP="${TMPDIR}/bin/lin64/setup"
	    ADD_LICENSE=false
	    PATCH_UPDATE=true
	    INSTALL_LOG="${CURDIR}/Xilinx/${VER}/.xinstall/install.log"
	    ;;
    esac

    if ! test -f "${INSTALL_LOG}" || ! grep -q "${SUCCESS_RE}" "${INSTALL_LOG}"; then

	banner "Unpack Xilinx ISE ${VER} tarball"
	if ! test -f "${TMPDIR}/.unpacked" && ! test -f "${INSTALL_LOG}"; then
	    echo "    Unpacking '${TARBALL}'"
	    echo "        into '${TMPDIR}'"
	    mkdir -p "${TMPDIR}"
	    tar xCf "${TMPDIR}" "${TARBALL}" --strip-components=1

	    if $PATCH_UPDATE; then
		echo "    Monkey-patching xilinxupdate not to run"
		mv "${TMPDIR}/bin/lin64/xilinxupdate" "${TMPDIR}/bin/lin64/xilinxupdate-"
		cp "${CURDIR}/lib/xilinxupdate" "${TMPDIR}/bin/lin64/"
	    fi

	    touch "${TMPDIR}/.unpacked"
	else
	    echo "    Xilinx tarball already unpacked"
	fi

	banner "Running Xilinx ISE ${VER} batch install"
	"${SETUP}" -batch "${CURDIR}/lib/ise-install-${VER}.conf"
    else
	banner "Unpack Xilinx ISE ${VER} tarball"
	echo "    Xilinx ${VER} ${SUITE} already installed"
    fi
    
    # Add license to license file
    if $ADD_LICENSE; then
	banner "Add Xilinx ISE ${VER} license to license file"
	if ! grep -q 'PACKAGE ISE_WebPACK xilinxd' "${LICENSE_FILE}"; then
	    if test -f "${TMPDIR_BASE}/Xilinx.lic"; then
		echo "    from '${TMPDIR_BASE}/Xilinx.lic'"
		echo "    to '${LICENSE_FILE}'"
		cat "${TMPDIR_BASE}/Xilinx.lic" >> "${LICENSE_FILE}"
	    else
		echo "ERROR:  No license file found in '${TMPDIR_BASE}/Xilinx.lic'!"
		exit 1
	    fi
	else
	    echo "    License already present in ${LICENSE_FILE}"
	fi
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


banner -1 "Starting install on $(date)"
install-ise 13.4
install-ise 10.1
clone-hm2-fw
banner -1 "Finished install on $(date)"
