#
# Removing network-sandbox is a hack, but it works and avoids explicitly listing all the modules in the ebuild.
#

EAPI=8

inherit go-module

EGO_PN="github.com/ScottESanDiego/${PN}"

DESCRIPTION="Remove files from a directory if they aren't actively used by Transmission"
HOMEPAGE="https://github.com/ScottESanDiego/transmission-filesync"

SRC_URI="https://github.com/ScottESanDiego/transmission-filesync/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"

S="${GODIR}"
LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror network-sandbox"

BDEPEND="dev-lang/go"

DEPEND="${RDEPEND}"

QA_PRESTRIPPED="usr/bin/transmission-filesync"

GODIR="${WORKDIR}/${P}"

src_compile() {
	GOPATH="${GODIR}" \

	BUILD_COMMAND="go build -v -work -x -a -ldflags -s"
	${BUILD_COMMAND} || die
}

src_install() {
	dobin ${PN}
}
