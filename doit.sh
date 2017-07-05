#!/bin/bash -xe

TMPDIR=/tmp/unpack
CURDIR="$PWD"
TARBALL="$CURDIR/ISE_DVD_92i.tar.gz"


doit() {
    # Unpack Xilinx ISE into temp directory
    mkdir -p $TMPDIR
    cd $TMPDIR
    if ! test -f .unpacked; then
	tar xzf $TARBALL --strip-components=1
	touch .unpacked
    fi

    # Run installer
    bin/lin64/setup
    
    # # Clean up
    # cd $CURDIR
    # rm -r $TMPDIR
}


doit
