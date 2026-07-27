EAPI="8"

DESCRIPTION="SSHGuard nftables firewall script for IPv4 only"
HOMEPAGE="https://scotte.ai/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=app-admin/sshguard-2.5.1"

S="${T}"

src_install() {
	insinto /usr/libexec
	doins "${FILESDIR}"/usr/libexec/sshg-fw-nft-sets-ipv4
	fperms 0755 /usr/libexec/sshg-fw-nft-sets-ipv4
}
