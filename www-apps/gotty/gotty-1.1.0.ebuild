# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/ScottESanDiego/gotty"
DESCRIPTION="A simple command line tool that turns your CLI tools into web applications"
HOMEPAGE="https://github.com/ScottESanDiego/gotty"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror network-sandbox"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"

IUSE=""
DEPEND="dev-lang/go"

QA_PRESTRIPPED="usr/bin/gotty"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	GOPATH="${G}" \
	go build -v -work -x -a -ldflags "-s -X 'main.Version=${PV}'" || die
}

src_install() {
	dobin gotty
}
