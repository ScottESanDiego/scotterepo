EAPI="8"

DESCRIPTION="Crowdsec collection: SSH timeout detection"
HOMEPAGE="https://scotte.ai/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=net-analyzer/crowdsec-1.7.8-r1"

S="${T}"

src_install() {
	insinto /etc/crowdsec/collections
	doins "${FILESDIR}"/etc/crowdsec/collections/scotte-ssh.yaml

	insinto /etc/crowdsec/parsers/s01-parse
	doins "${FILESDIR}"/etc/crowdsec/parsers/s01-parse/custom-ssh-timeout.yaml
}

pkg_postinst() {
	ewarn "After installation, run the following command to activate the collection:"
	ewarn "  cscli collections install scotte/ssh"
}
