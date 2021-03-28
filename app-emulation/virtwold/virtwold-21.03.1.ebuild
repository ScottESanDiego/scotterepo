#
# This should really use go-module and specify dependencies, rather than removing the network-sandbox
#

EAPI=7

inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/ScottESanDiego/${PN}"

KEYWORDS="~amd64"

SRC_URI="https://github.com/ScottESanDiego/virtwold/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"

RESTRICT="mirror network-sandbox"

DESCRIPTION="Wake-on-LAN for libvirt based VMs"
HOMEPAGE="https://github.com/ScottESanDiego/virtwold"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
IUSE="static"
BDEPEND="dev-lang/go
		static? ( net-libs/libpcap[static-libs(+)] )"

RDEPEND="!static? ( net-libs/libpcap )"

QA_PRESTRIPPED="usr/bin/virtwold"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"


src_compile() {
	GOPATH="${G}" \

if use static; then
	BUILD_COMMAND="LDFLAGS='-l/usr/lib/x86_64-linux-gnu/libpcap.a' CGO_ENABLED=1 go build -v -work -x -a -ldflags '-linkmode external -extldflags -static -s'"
else
	BUILD_COMMAND="go build -v -work -x -a -ldflags -s"
fi
	${BUILD_COMMAND} || die
}

src_install() {
	dobin ${PN}
	newinitd "${FILESDIR}"/virtwold.initd virtwold
	newconfd "${FILESDIR}"/virtwold.confd virtwold
}
