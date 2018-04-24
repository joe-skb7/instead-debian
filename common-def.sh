#!/bin/sh

# Commonly used variables and functions

# ---- AUX FUNCTIONS ----

# $1: path to packet dir that contains debian/ dir
extract_ver() {
	ls -1 $1 | grep '.orig.tar.gz$' | \
		sed -rn 's/.*_(.*)\.orig\.tar\.gz/\1/p'
}

# $1: path to packet dir that contains debian/ dir
extract_verd() {
	cat $1/debian/changelog | head -1 | sed -rn 's/.*\((.*)\).*/\1/p'
}

# ---- VARIABLES ----

# INSTEAD version, in format x.y.z
ver=$(extract_ver .)
# +debian packaging ver, like x.y.z-d
verd=$(extract_verd .)
instead_dir=instead-$ver
instead_orig_tar=instead_$ver.orig.tar.gz
cur_dir=$(pwd)
home_dir=$(echo ~)

build_files="\
instead_${verd}_amd64.deb \
instead_${verd}_amd64.build \
instead_${verd}_amd64.changes \
instead-dbgsym_${verd}_amd64.deb \
instead_${verd}_amd64.buildinfo \
instead_${verd}_source.changes \
instead_${verd}.debian.tar.xz \
instead_${verd}.dsc \
instead-data_${verd}_all.deb"
# _source.changes is only created by i386 build process

# ---- FUNCTIONS ----

clean() {
	echo
	echo "---> Cleaning build files..."

	rm -rf $build_files
	rm -rf $instead_dir

	echo "=== Cleaning build files [OK]"
}

prepare() {
	echo
	echo "---> Preparing for building..."

	if [ ! -f $instead_orig_tar ]; then
		echo "Error: Orig tarball not found" >&2
		exit 1
	fi

	tar -xzf $instead_orig_tar

	old_deb_dir="$instead_dir/debian"
	new_deb_dir="debian"
	rm -rf $old_deb_dir
	cp -R $new_deb_dir $old_deb_dir

	echo "=== Preparing for building [OK]"
}
