#
# Requires 'FEATURES="-network-sandbox"' to build.
#

EAPI=8

inherit go-module

DESCRIPTION="MTA that uses the Google GMail API for submission "
HOMEPAGE="https://codeberg.org/scotte/gmail-api-client"

EGO_PN="codeberg.org/scotte/${PN}"
SRC_URI="https://codeberg.org/scotte/gmail-api-client/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

BDEPEND=">=dev-lang/go-1.26"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

OWNERS="/etc/mail/gmail-api-transport/config.json.example:mail:mail"

src_compile() {
	ego build -o gmail-api-transport cmd/gmail-api-transport/main.go
	ego build -o gmail-api-transport-get-token cmd/gmail-api-transport-get-token/main.go
}

src_install() {
	dobin gmail-api-transport
	dobin gmail-api-transport-get-token
	insinto /usr/share/doc/${PF}/examples
	doins config.json.example
}
