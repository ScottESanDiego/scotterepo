# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="Tools for Flash-Friendly File System (F2FS)"
HOMEPAGE="https://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git/about/"
#SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/snapshot/${P}.tar.gz"
EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git"
EGIT_COMMIT="a60cd1a3f96645326fd05d5ab4f72fe2ca9be2ff"

LICENSE="GPL-2"
SLOT="0/6"
KEYWORDS="amd64 arm arm64 ~mips ppc ppc64 x86"
IUSE="selinux"

RDEPEND="
	selinux? ( sys-libs/libselinux )
	elibc_musl? ( sys-libs/queue-standalone )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	#This is required to install to /sbin, bug #481110
	econf \
		--bindir="${EPREFIX}"/sbin \
		--disable-static \
		$(use_with selinux)
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}
