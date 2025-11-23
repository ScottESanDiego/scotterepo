#
# Using git-r3 and EGIT_* is a hack, but it works and avoids explicitly listing all the modules in the ebuild.
#

EAPI=8

inherit go-module git-r3

EGO_PN="github.com/ScottESanDiego/${PN}"
EGIT_REPO_URI="https://github.com/ScottESanDiego/qbittorrent-filesync"
EGIT_COMMIT=${PV}

DESCRIPTION="Remove files from a directory if they aren't actively used by qBittorrent"
HOMEPAGE="https://github.com/ScottESanDiego/qbittorrent-filesync"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT+="strip"

BDEPEND="dev-lang/go"

DEPEND="${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	ego build -v -work -x -a -ldflags -s
}

src_install() {
	dobin ${PN}
}
