#
# Removing network-sandbox is a hack, but it works and avoids explicitly listing all the modules in the ebuild.
#

EAPI=8

inherit go-module

EGO_PN="github.com/ScottESanDiego/${PN}"

KEYWORDS="~amd64"

SRC_URI="https://github.com/ScottESanDiego/gmail-api-client/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"

RESTRICT="mirror network-sandbox"

DESCRIPTION="MTA that uses the Google GMail API for submission "
HOMEPAGE="https://github.com/ScottESanDiego/gmail-api-client"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
BDEPEND="dev-lang/go"

RDEPEND=""

DEPEND="${RDEPEND}"

QA_PRESTRIPPED="usr/bin/gmail-api-transport"

OWNERS="/etc/mail/gmail-api-transport/config.json.example:mail:mail"

G="${WORKDIR}/${P}"
S="${G}"

src_compile() {
	ego build -ldflags="-s -w" -o gmail-api-transport cmd/gmail-api-transport/main.go
	ego build -ldflags="-s -w" -o gmail-api-transport-get-token cmd/gmail-api-transport-get-token/main.go
}

src_install() {
	dobin gmail-api-transport
	dobin gmail-api-transport-get-token
	insinto /usr/share/doc/${PF}/examples
	doins config.json.example
}
