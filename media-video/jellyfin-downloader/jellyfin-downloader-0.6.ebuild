# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit python-single-r1

DESCRIPTION="Download movies and TV series from a Jellyfin server"
HOMEPAGE="https://github.com/KodeZ/JellyfinDownloader"
SRC_URI="https://github.com/KodeZ/JellyfinDownloader/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/JellyfinDownloader-${PV}"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/requests-2.28[${PYTHON_USEDEP}]
		>=dev-python/rich-13.0[${PYTHON_USEDEP}]
		>=dev-python/textual-0.60[${PYTHON_USEDEP}]
	')
"

PATCHES=( "${FILESDIR}/${P}-xdg-config.patch" )

src_install() {
	python_domodule jellydown
	python_newscript jellydown.py jellydown
}
