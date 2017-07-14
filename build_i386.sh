#!/bin/sh

# Before running this script, run next command:
#     $ DIST=testing ARCH=i386 sudo -E pbuilder create

. ./common-def.sh

# ---- VARIABLES ----

dist=testing
arch=i386
result_dir_i386="/var/cache/pbuilder/$dist-$arch/result/"
build_dir_i386=./build_$arch
user=$USER

# ---- FUNCTIONS ----

clean_prev_result_i386() {
	echo
	echo "---> Cleaning previous result files for i386..."
	sudo rm -rf "$result_dir_i386"
	echo "=== Cleaning previous result files for i386 [OK]"
}

build_i386() {
	echo
	echo "---> Start building deb for architecture i386..."

	cd $instead_dir
	DIST=$dist ARCH=$arch sudo -E pdebuild
	res=$?
	cd $cur_dir
	if [ $res -eq 0 ]; then
		echo "=== Building deb [OK]"
	else
		echo "=== Building deb [FAILED]" >&2
		exit 1
	fi
}

rm_build_dir() {
	rm -rf "$build_dir_i386"
}

move_result_i386() {
	echo
	echo "---> Moving result files for i386..."

	sudo chown -R $user:$user $result_dir_i386
	rm_build_dir
	mkdir "$build_dir_i386"
	cp -Rf $result_dir_i386/* $build_dir_i386
	cp -f instead_*.orig.tar.gz "$build_dir_i386"
	rm -f instead_${verd}_source.changes # unnecessary file

	echo "=== Moving result files for i386 [OK]"
}

sign_i386() {
	echo
	echo "---> Signing of changes file... "
	debsign $build_dir_i386/instead_${verd}_$arch.changes
	if [ $? -ne 0 ]; then
		echo "=== Signing [FAIL]" >&2
		exit 1
	fi
	echo "=== Signing [OK]"
}

test_if_run_from_build_sh() {
	if [ -z "$RUN_FROM_BUILD_SH" ]; then
		echo "Error: Please run build.sh script instead of this one" >&2
		exit 1
	fi
}

# ---- ENTRY POINT ----

test_if_run_from_build_sh

case "$1" in
	"-c"|"--clean")
		clean
		;;
	"-dc"|"--distclean")
		clean
		rm_build_dir
		;;
	"-p"|"--prepare")
		prepare
		;;
	"-b"|"--build")
		build
		;;
	"-a"|"--all")
		clean
		prepare
		clean_prev_result_i386
		build_i386
		move_result_i386
		sign_i386
		clean
		;;
	*)
		echo "Error: Invalid arguments" >&2
		exit 1
esac
