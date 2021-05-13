# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils multilib

DESCRIPTION="nvidia-container-runtime"
HOMEPAGE="https://github.com/NVIDIA"
KEYWORDS="*"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="$COMMON_DEPEND >=dev-lang/go-1.4
	>=app-emulation/nvidia-container-toolkit-1.4.2"

TARBALL_PV=${PV}

NV_GITHUB_REPO="nvidia-container-runtime"
NV_GITHUB_USER="NVIDIA"

SRC_URI="https://www.github.com/${NV_GITHUB_USER}/${NV_GITHUB_REPO}/archive/v${PV}.tar.gz -> ${NV_GITHUB_REPO}-${PV}.tar.gz"

src_prepare() {
	default
	# This whole src thing is a kludge!
	mkdir $WORKDIR/../src
}

src_compile() {
	# This whole src thing is a kludge!
	export GOPATH=`pwd`/../src
	cd src
	make build
}

src_install() {
	# This whole src thing is a kludge!
	cd src
	insinto /usr/bin
	doins nvidia-container-runtime
	fperms 755 /usr/bin/nvidia-container-runtime
}
