# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit go-module

DESCRIPTION="Mirror Fastmail mail to Gmail using JMAP and the Gmail API"
HOMEPAGE="https://github.com/ScottESanDiego/jmap2gmail"
SRC_URI="https://github.com/ScottESanDiego/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

# Licenses of the Go dependencies.
LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="app-misc/ca-certificates"
BDEPEND=">=dev-lang/go-1.27.2"

# Dependencies are fetched during the build, as with gmail-api-client.
pkg_setup() {
	if has network-sandbox ${FEATURES}; then
		eerror "Go module downloads require network access during the build."
		eerror "Add this line to /etc/portage/package.env:"
		eerror "mail-mta/${PN} no-net-sandbox"
		eerror "The no-net-sandbox environment must set FEATURES=\"-network-sandbox\"."
		die "Disable network-sandbox for this package"
	fi
}

src_compile() {
	ego build -mod=readonly -trimpath -o jmap2gmail ./cmd/jmap2gmail
}

src_test() {
	ego test -mod=readonly ./...
}

src_install() {
	dobin jmap2gmail
	insinto /etc/jmap2gmail
	doins config.example.json
}

pkg_postinst() {
	elog "Copy ${EROOT}/etc/jmap2gmail/config.example.json to your own config.json."
	elog "Configure credentials, then run jmap2gmail google-auth -config /path/to/config.json."
	elog "Run jmap2gmail sync -config /path/to/config.json --dry-run before the first sync."
}
