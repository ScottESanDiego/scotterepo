# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit python-single-r1 systemd

DESCRIPTION="Script/daemon to block IPs in nftables by country and blacklists"
HOMEPAGE="https://github.com/tomasz-c/nft-blackhole"
SRC_URI="https://github.com/tomasz-c/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+ipv6 systemd"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	net-firewall/nftables
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# If IPv6 is disabled, change nftables table from "inet" to "ip" (IPv4 only)
	if ! use ipv6; then
		# Change table type from inet to ip
		sed -i 's/table inet/table ip/g' nft-blackhole.py || die "sed failed"
		sed -i 's/table inet/table ip/g' nft-blackhole.template || die "sed failed"

		# Remove IPv6 sets and rules from template file
		sed -i '/set whitelist-v6/,/^[[:space:]]*}$/d' nft-blackhole.template || die "sed failed"
		sed -i '/set blacklist-v6/,/^[[:space:]]*}$/d' nft-blackhole.template || die "sed failed"
		sed -i '/set country-v6/,/^[[:space:]]*}$/d' nft-blackhole.template || die "sed failed"
		sed -i '/ip6 saddr/d' nft-blackhole.template || die "sed failed"

		# Remove IPv6 rules from Python script templates
		sed -i '/\\tip6 saddr @whitelist-v6/d' nft-blackhole.py || die "sed failed"
		sed -i '/\\tip6 saddr @blacklist-v6/d' nft-blackhole.py || die "sed failed"
		sed -i '/\\tip6 saddr @country-v6/d' nft-blackhole.py || die "sed failed"
		sed -i '/\\tip6 daddr @whitelist-v6/d' nft-blackhole.py || die "sed failed"
		sed -i 's/\\tip6 daddr @blacklist-v6 counter \${block_policy}\\n//' nft-blackhole.py || die "sed failed"
	fi
}

src_install() {
	# Install Python script
	python_doscript nft-blackhole.py

	# Install configuration file
	insinto /etc
	doins nft-blackhole.conf

	# Install template file
	insinto /usr/share/nft-blackhole
	doins nft-blackhole.template

	# Install init system files
	if use systemd; then
		systemd_dounit nft-blackhole.service
		systemd_dounit nft-blackhole-reload.service
		systemd_dounit nft-blackhole-reload.timer
	else
		newinitd "${FILESDIR}"/nft-blackhole.initd nft-blackhole
		newconfd "${FILESDIR}"/nft-blackhole.confd nft-blackhole
	fi

	# Install documentation
	dodoc README.md

	# Create necessary directories
	keepdir /var/lib/nft-blackhole
}

pkg_postinst() {
	elog "nft-blackhole has been installed."
	elog ""
	elog "Configuration file: /etc/nft-blackhole.conf"
	elog ""
	if use systemd; then
		elog "To enable and start the service:"
		elog "  systemctl enable --now nft-blackhole.service"
		elog ""
		elog "To enable automatic list refreshing:"
		elog "  systemctl enable --now nft-blackhole-reload.timer"
		elog ""
	else
		elog "To enable and start the service (OpenRC):"
		elog "  rc-update add nft-blackhole default"
		elog "  rc-service nft-blackhole start"
		elog ""
		elog "To reload blacklists (OpenRC):"
		elog "  rc-service nft-blackhole reload"
		elog ""
		elog "For automatic list refreshing, add to crontab:"
		elog "  0 */6 * * * /etc/init.d/nft-blackhole reload"
		elog ""
	fi
	elog "Manual usage:"
	elog "  nft-blackhole.py start|stop|restart|reload"
	elog ""
	elog "Please edit /etc/nft-blackhole.conf before starting the service."
	elog ""
	if use ipv6; then
		elog "IPv6 support: ENABLED (nftables 'inet' table)"
	else
		elog "IPv6 support: DISABLED (nftables 'ip' table, IPv4 only)"
	fi
	ewarn "This package modifies your system's firewall rules."
	ewarn "Make sure you configure it properly to avoid blocking legitimate traffic."
}
