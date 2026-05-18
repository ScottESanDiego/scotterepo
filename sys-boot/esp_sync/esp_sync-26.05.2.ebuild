#
# Requires 'FEATURES="-network-sandbox"' to build.
#

EAPI=8

inherit go-module

DESCRIPTION="Daemon to keep two EFI System Partitions in sync (one-way sync)"
HOMEPAGE="https://codeberg.org/scotte/esp_sync"

EGO_PN="codeberg.org/scotte/${PN}"
SRC_URI="https://codeberg.org/scotte/esp_sync/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

BDEPEND=">=dev-lang/go-1.26.2"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

src_compile() {
	ego build -o ${PN}
}

src_install() {
	dobin ${PN}

	newinitd "${S}/init-scripts/openrc/esp_sync.initd" esp_sync
	newconfd "${S}/init-scripts/openrc/esp_sync.confd" esp_sync
}
