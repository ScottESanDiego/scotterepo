# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit go-module

DESCRIPTION="Sendmail-compatible JMAP client"
HOMEPAGE="https://git.sr.ht/~rockorager/mjmap"
SRC_URI="
	https://git.sr.ht/~rockorager/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ScottESanDiego/scotterepo/releases/download/mjmap-${PV}/${P}-vendor.tar.xz
"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="Apache-2.0 BSD MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mta"

RDEPEND="
	net-mail/mailbase
	mta? (
		!mail-mta/courier
		!mail-mta/esmtp
		!mail-mta/exim
		!mail-mta/msmtp[mta]
		!mail-mta/netqmail
		!mail-mta/notqmail
		!mail-mta/nullmailer
		!mail-mta/opensmtpd[mta]
		!mail-mta/postfix
		!mail-mta/sendmail
		!mail-mta/ssmtp[mta]
	)
"
BDEPEND="
	acct-user/mail
	app-text/scdoc
"

PATCHES=( "${FILESDIR}/${P}-system-config.patch" )

src_compile() {
	local ldflags=(
		"-X main.Version=v${PV}"
		"-X main.Date=2026-08-04"
		"-X main.defaultConfigPath=${EPREFIX}/etc/mail/mjmap"
	)

	ego build -trimpath -ldflags "${ldflags[*]}" -o mjmap .
	scdoc < mjmap.1.scd > mjmap.1 || die "scdoc failed"
}

src_test() {
	ego test ./...
}

src_install() {
	dobin mjmap
	use mta && dosym mjmap /usr/bin/sendmail

	doman mjmap.1
	einstalldocs

	insinto /etc/mail
	newins config_sample.scfg mjmap
	fperms 0600 /etc/mail/mjmap
	fowners mail:mail /etc/mail/mjmap
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Configure mjmap in ${EROOT}/etc/mail/mjmap."
		elog "The private system configuration is readable only by the mail user."
		if use mta; then
			elog "The sendmail command must therefore be invoked as the mail user,"
			elog "or with an explicitly supplied configuration readable by its caller."
		fi
	fi
}
