# Distributed under the terms of the GNU General Public License v2
#
# This is a kludge to pull in a psuedo-nightly for testing

EAPI=7

inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/markusressel/${PN}"

DESCRIPTION="A simple daemon providing dynamic fan speed control"
HOMEPAGE="https://github.com/markusressel/fan2go"
COMMIT="5cc667ac816955df14224c20329f2134badc572d"
SRC_URI="https://github.com/markusressel/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror network-sandbox"

LICENSE="AGPL-3 Apache-2.0 MIT BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sys-apps/lm-sensors"
RDEPEND="${DEPEND}"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	SOURCE_DATE_EPOCH=$(date +%s || die)
	DATE=$(date -u -d @${SOURCE_DATE_EPOCH} +"%Y-%m-%dT%H:%M:%SZ" || die)

	BUILD_COMMAND='go build -o fan2go -x -v -a -tags netgo -ldflags -s .'
	${BUILD_COMMAND} || die

	# Here's what the go-module version used to build.  We're ignoring it. :-)
#	ego \
#		build \
#		-o fan2go \
#		-x \
#		-v \
#		${GOFLAGS} \
#		-ldflags "-X fan2go/cmd.version=${PV} -X fan2go/cmd.date=${DATE}" \
#		-a \
#		-tags netgo \
#		.
}

src_install() {
	dobin fan2go
	dodoc README.md
	insinto /etc/fan2go
	doins fan2go.yaml
}

src_test() {
	ego test -v ./... || die
}
