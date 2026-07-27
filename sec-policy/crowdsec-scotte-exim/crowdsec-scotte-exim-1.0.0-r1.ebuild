EAPI="8"

DESCRIPTION="Crowdsec collection: Exim SMTP abuse detection"
HOMEPAGE="https://scotte.ai/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=net-analyzer/crowdsec-1.7.8-r1"

S="${T}"

src_install() {
	insinto /etc/crowdsec/collections
	doins "${FILESDIR}"/etc/crowdsec/collections/scotte-exim.yaml

	insinto /etc/crowdsec/parsers/s00-raw
	doins "${FILESDIR}"/etc/crowdsec/parsers/s00-raw/exim-syslog-fix.yaml

	insinto /etc/crowdsec/parsers/s01-parse
	doins "${FILESDIR}"/etc/crowdsec/parsers/s01-parse/scotte-exim-auth-abuse.yaml

	insinto /etc/crowdsec/scenarios
	doins "${FILESDIR}"/etc/crowdsec/scenarios/scotte-exim-auth-abuse.yaml
}

pkg_postinst() {
	ewarn "After installation, run the following command to activate the collection:"
	ewarn "  cscli collections install scotte/exim"
}
