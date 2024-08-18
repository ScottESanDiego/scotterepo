# ebuild for CH343 USB Serial Driver

EAPI=8

inherit linux-mod-r1

DESCRIPTION="CH343 module for Linux kernel"
HOMEPAGE="https://github.com/WCHSoftGroup/ch343ser_linux"
COMMIT="6255aaa2bf60933d315c3158013c2cdc6547fadd"
SRC_URI="https://github.com/WCHSoftGroup/ch343ser_linux/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}_linux-${COMMIT}/driver"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~x86"

src_compile() {
	local modlist=( ch343 )
	local modargs=( KERNELDIR=${KERNEL_DIR} )
	linux-mod-r1_src_compile
}
