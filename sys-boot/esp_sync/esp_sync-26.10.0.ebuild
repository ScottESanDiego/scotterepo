#
# Requires 'FEATURES="-network-sandbox"' to build, since 'go build' fetches
# modules from goproxy instead of vendored distfiles.  This is provided by
# the 'no-net-sandbox' entry for sys-boot/esp_sync in package.env.
#
# Upstream moved back to GitHub from codeberg.org, so this version fetches
# from GitHub again.

EAPI=9

inherit go-module

DESCRIPTION="Daemon to keep two EFI System Partitions in sync (one-way sync)"
HOMEPAGE="https://github.com/ScottESanDiego/esp_sync"
SRC_URI="https://github.com/ScottESanDiego/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64"

# go.mod requires go >= 1.27.0
BDEPEND=">=dev-lang/go-1.27.0"

RESTRICT="mirror"

# -buildvcs=false: the release archive has no VCS repo, and go 1.27 errors
# out when stamping fails instead of skipping.
src_compile() {
	ego build -buildvcs=false -o ${PN}
}

src_test() {
	ego test -buildvcs=false ./...
}

src_install() {
	dobin ${PN}

	newinitd "${S}/init-scripts/openrc/esp_sync.initd" esp_sync
	newconfd "${S}/init-scripts/openrc/esp_sync.confd" esp_sync
}
