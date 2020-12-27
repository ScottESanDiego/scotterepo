# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NVIDIA_DRIVER=460.27.04
ELF_VERSION=0.7.1
ELF_PREFIX=elftoolchain-${ELF_VERSION}

inherit git-r3

DESCRIPTION="This provides a library and a simple CLI utility to automatically configure GNU/Linux containers leveraging NVIDIA hardware.
The implementation relies on kernel primitives and is designed to be agnostic of the container runtime."
HOMEPAGE=""

SRC_URI="
https://github.com/NVIDIA/nvidia-modprobe/archive/${NVIDIA_DRIVER}.tar.gz
https://sourceforge.net/projects/elftoolchain/files/Sources/${ELF_PREFIX}/${ELF_PREFIX}.tar.bz2
"

EGIT_REPO_URI="https://github.com/NVIDIA/libnvidia-container.git"
EGIT_COMMIT="v${PV}"

LICENSE="NVIDIA CORPORATION"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/0001_fix_curl_downloads-${NVIDIA_DRIVER}.patch"
	"${FILESDIR}/nvc_api.patch"
)

DEPEND="
	~x11-drivers/nvidia-drivers-${NVIDIA_DRIVER}-r1[uvm]
	net-libs/libtirpc
	net-libs/rpcsvc-proto
"

RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/bmake
	sys-apps/lsb-release
"

#S="${WORKDIR}/${PN}_${PV}"

QA_PREBUILT="/usr/bin/nvidia-container-cli"
QA_PRESTRIPPED="/usr/bin/nvidia-container-cli"
QA_PRESTRIPPED="/usr/lib64/libnvidia-container.so.*"

src_compile() {
	export WITH_LIBELF=yes
	export WITH_TIRPC=no
	export WITH_SECOMP=yes
	make shared static tools
}

src_install() {
	emake DESTDIR="${D}" install
	rm ${D}/usr/include/elf*
	rm ${D}/usr/include/gelf.h
	rm ${D}/usr/include/libelf.h

	rm ${D}/usr/lib64/*libel*
}

