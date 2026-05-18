#
# Removing network-sandbox is a hack, but it works and avoids explicitly listing all the modules in the ebuild.
#

EAPI=8

inherit go-module

EGO_PN="github.com/ScottESanDiego/${PN}"

KEYWORDS="~amd64"

SRC_URI="https://github.com/ScottESanDiego/esp_sync/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"

RESTRICT="mirror network-sandbox"

DESCRIPTION="Daemon to keep two EFI System Partitions in sync (one-way sync)"
HOMEPAGE="https://github.com/ScottESanDiego/esp_sync"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
BDEPEND="dev-lang/go"

RDEPEND=""

DEPEND="${RDEPEND}"

QA_PRESTRIPPED="usr/bin/esp_sync"

G="${WORKDIR}/${P}"
S="${G}"


src_compile() {
	GOPATH="${G}" \

	BUILD_COMMAND="go build -v -work -x -a -ldflags -s"

	${BUILD_COMMAND} || die
}

src_install() {
	dobin ${PN}
	newinitd "${S}/init-scripts/openrc/esp_sync.initd" esp_sync
	newconfd "${S}/init-scripts/openrc/esp_sync.confd" esp_sync
}
