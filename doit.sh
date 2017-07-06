#!/bin/bash -xe

CURDIR="$PWD"
TMPDIR="$CURDIR/unpack"
TARBALL="$CURDIR/Xilinx_ISE_DS_Lin_13.4_O.87xd.3.0.tar"


doit() {
    # Unpack Xilinx ISE into temp directory
    mkdir -p "${TMPDIR}"
    if ! test -f "${TMPDIR}/.unpacked"; then
	tar xCf "${TMPDIR}" "${TARBALL}" --strip-components=1
	touch "${TMPDIR}/.unpacked"
    fi

    # Run installer
    "${TMPDIR}/xsetup"
    
    # # Clean up
    # cd $CURDIR
    # rm -r $TMPDIR
}


doit
