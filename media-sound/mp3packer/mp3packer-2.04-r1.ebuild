EAPI=7

inherit git-r3 toolchain-funcs

MY_PV="41704aa"
EGIT_REPO_URI="https://github.com/ScottESanDiego/mp3packer.git"

DESCRIPTION="An MP3 reorganizer"
HOMEPAGE="https://hydrogenaud.io/index.php/topic,32379.575.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/ocaml[ocamlopt]"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ${PN}
}
