# ebuild for CH343 USB Serial Driver

EAPI=8

inherit linux-mod-r1

DESCRIPTION="Nuvoton NCT6687-R module for Linux kernel"
HOMEPAGE="https://github.com/Fred78290/nct6687d"
COMMIT="0ee35ed9541bde22fe219305d1647b51ed010c5e"
SRC_URI="https://github.com/Fred78290/nct6687d/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~x86"

src_compile() {
	local modlist=( nct6687 )
	local modargs=( KERNELDIR=${KERNEL_DIR} )
	linux-mod-r1_src_compile
}

src_install() {
	linux_domodule ${KV_FULL}/nct6687.ko
}
