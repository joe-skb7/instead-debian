# INSTEAD Debian Package

Debian packaging repo for [INSTEAD](https://github.com/instead-hub/instead/).

## Prerequisites

Install Debian maintenance tools:
```bash
$ sudo aptitude install devscripts pbuilder
```

Install INSTEAD build dependencies: see INSTALL file in
[INSTEAD](https://github.com/instead-hub/instead/) project.

## Building

First of all, download last INSTEAD source tarball to this directory (before
building the package), along with the signature file:

```bash
$ wget https://downloads.sourceforge.net/project/instead/instead/3.2.1/instead_3.2.1.tar.gz -O instead_3.2.1.orig.tar.gz
$ wget https://downloads.sourceforge.net/project/instead/instead/3.2.1/instead_3.2.1.tar.gz.asc -O instead_3.2.1.orig.tar.gz.asc
```

Now you can build the package using next command:

```bash
$ ./build.sh -amd64
```

Built packages will be placed into `build_amd64/` dir.

## Authors

* **Sam Protsenko**

## License

This project is licensed under the GPLv2.
