# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

RESTRICT="mirror"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
case ${PV} in
99999999*)
	EGIT_REPO_URI="https://github.com/zsh-users/zsh-autosuggestions"
	EGIT_BRANCH="develop"
	inherit git-r3
	PROPERTIES="live"
	SRC_URI=""
	KEYWORDS="";;
*alpha*)
	EGIT_COMMIT="4838222dde4e286b6861bb83bc21f0a3d50b7a5f"
	SRC_URI="https://github.com/zsh-users/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}";;
*)
	SRC_URI="https://github.com/zsh-users/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz";;
esac

DESCRIPTION="Fish-like autosuggestions for zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-autosuggestions/"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="app-shells/zsh"
DEPEND=""

src_install() {
	local DISABLE_AUTOFORMATTING DOC_CONTENTS dir
	dir="/usr/share/zsh/site-contrib/${PN}"
	DISABLE_AUTOFORMATTING="true"
	DOC_CONTENTS="In order to use ${CATEGORY}/${PN} add
. ${EPREFIX}${dir}/zsh-autosuggestions.zsh"'
at the end of your ~/.zshrc
For testing, you can also execute the above command in your zsh.'
	readme.gentoo_create_doc
	insinto "${dir}"
	doins *.zsh
	doins -r spec src
	dodoc *.md
}

pkg_postinst() {
	readme.gentoo_print_elog
}
