# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_{8,9,10} )

inherit python-any-r1 readme.gentoo-r1

DESCRIPTION="UEFI firmware for 64-bit x86 virtual machines"
HOMEPAGE="https://github.com/tianocore/edk2"

#BUNDLED_OPENSSL_SUBMODULE_SHA="e2e09d9fba1187f8d6aafaa34d4172f56f1ffb72"
#BUNDLED_BROTLI_SUBMODULE_SHA="666c3280cc11dc433c303d79a83d4ffbdd12cc8d"

# TODO: talk with tamiko about unbundling (mva)

# TODO: the binary 202105 package currently lacks the preseeded
#       OVMF_VARS.secboot.fd file (that we typically get from fedora)

#SRC_URI="
#	binary? ( https://archlinux.org/packages/extra/any/edk2-ovmf/download )
#"

LICENSE="BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64"

IUSE="+binary"
REQUIRED_USE+="
	!amd64? ( binary )
"

RDEPEND=""

#S="${WORKDIR}/files/"
S="${WORKDIR}/../files/"

pkg_setup() {
	[[ ${PV} != "999999" ]] && use binary || python-any-r1_pkg_setup
}

src_prepare() {
	if use binary; then
		eapply_user
	fi
}

src_install() {
#	insinto /usr/share/${PN}
	insinto /usr/share/edk2-ovmf/
	doins *

#	insinto /usr/share/qemu/firmware
#	doins /usr/share/edk2-ovmf/x64/*
#	newbin OVMF_CODE.fd /usr/share/qemu/edk2-x86_64-code.fd
#	newbin OVMF_CODE.secboot.fd /usr/share/qemu/edk2-x86_64-secure-code.fd
}
