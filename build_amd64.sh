#!/bin/sh

. ./common-def.sh

# ---- VARIABLES ----

build_dir_amd64=./build_amd64

# ---- FUNCTIONS ----

build() {
	echo
	echo "---> Start building deb..."

	cd $instead_dir
	debuild -sa --lintian-opts -i
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
	rm -rf "$build_dir_amd64"
}

move() {
	echo
	echo "---> Moving files to build dir..."

	rm_build_dir
	mkdir "$build_dir_amd64"
	for f in $build_files; do
		if [ "$f" = instead_${verd}_source.changes ]; then
			# i386 build file; don't process it
			continue
		fi
		if [ ! -f "$f" ]; then
			echo "Error: File doesn't exist, can't move: $f" >&2
			exit 1
		fi
		mv $f "$build_dir_amd64"
	done
	cp -f instead_*.orig.tar.gz "$build_dir_amd64"
	cp -f instead_*.orig.tar.gz.asc "$build_dir_amd64"

	echo "=== Moving files to build dir [OK]"
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
		build
		move
		clean
		;;
	*)
		echo "Error: Invalid arguments" >&2
		exit 1
esac
