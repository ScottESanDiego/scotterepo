# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Omnissa Horizon View client"
HOMEPAGE="https://docs.omnissa.com/de-DE/bundle/HorizonOverviewDeployment/page/AboutHorizon8.html"
SRC_URI="https://download3.omnissa.com/software/CART25FQ4_LIN_2412_TARBALL/Omnissa-Horizon-Client-Linux-2412-${PV}-12437214089.tar.gz -> ${PF}.tar.gz"

RESTRICT="mirror"

LICENSE="omnissa"
SLOT="0/2412"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
    app-arch/bzip2
    dev-libs/atk
    dev-libs/expat
    dev-libs/fribidi
    dev-libs/glib
    dev-libs/icu
    dev-libs/libbsd
    dev-libs/libffi
    dev-libs/libpcre
    dev-libs/libsigc++
    dev-libs/libxml2
    media-gfx/graphite2
    media-libs/fontconfig
    media-libs/freetype
    media-libs/harfbuzz
    media-libs/libpng
    sys-apps/util-linux
    sys-devel/gcc
    sys-libs/glibc
    sys-libs/zlib
    x11-libs/cairo
    x11-libs/gdk-pixbuf:2
    x11-libs/gtk+:3
    x11-libs/libX11
    x11-libs/libXScrnSaver
    x11-libs/libXau
    x11-libs/libXcomposite
    x11-libs/libXcursor
    x11-libs/libXdamage
    x11-libs/libXdmcp
    x11-libs/libXext
    x11-libs/libXfixes
    x11-libs/libXi
    x11-libs/libXinerama
    x11-libs/libXrandr
    x11-libs/libXrender
    x11-libs/libXtst
    x11-libs/libxcb
    x11-libs/libxkbfile
    x11-libs/pango
    x11-libs/pixman
"
RDEPEND="${DEPEND}"

QA_PREBUILT="
    usr/lib64/*
    usr/lib64/pcoip/vchan_plugins/*
    usr/lib64/omnissa/gcc/*
    usr/lib64/omnissa/*
    usr/lib64/omnissa/view/vdpService/*
    usr/lib64/omnissa/view/software/*
    usr/lib64/omnissa/view/vaapi/*
    usr/lib64/omnissa/view/lib/*
    usr/lib64/omnissa/view/vaapi2.7/*
    usr/lib64/omnissa/view/vdpau/*
    usr/lib64/omnissa/view/vaapi2/*
"

src_unpack() {
    default
    # getting client from tgz
    #unpack "${WORKDIR}"/*/x64/Omnissa-Horizon-Client-Linux-ClientSDK-${SLOT#*/}-${PV}-*.tar.gz
    unpack "${WORKDIR}"/*/x64/Omnissa-Horizon-Client-${SLOT#*/}-${PV}-*.tar.gz
    unpack "${WORKDIR}"/*/x64/Omnissa-Horizon-FileAssociation-${SLOT#*/}-${PV}-*.tar.gz
    unpack "${WORKDIR}"/*/x64/Omnissa-Horizon-PCoIP-${SLOT#*/}-${PV}-*.tar.gz
    unpack "${WORKDIR}"/*/x64/Omnissa-Horizon-USB-${SLOT#*/}-${PV}-*.tar.gz
    unpack "${WORKDIR}"/*/x64/Omnissa-Horizon-USB-sdk-${SLOT#*/}-${PV}-*.tar.gz

    # make the client the new source
    mv "${WORKDIR}"/Omnissa-Horizon-Client-${SLOT#*/}-${PV}-*.x64 ${S}
}

src_prepare() {
    default

    # correcting lib path (strict-multilib)
    mv "${S}"/usr/lib "${S}"/usr/lib64

    # removing un-needed docs (willl reinstall them later)
    mv "${S}"/usr/share/doc/omnissa-horizon-client "${WORKDIR}/${P}_docs"

    # patching lib-path inside binaries
    sed -i 's~/usr/lib/~/usr/lib64/~g' "${S}"/usr/bin/omnissa-* || die "couldn't patch library path"

    # copying libs into client directory
    cp -a "${WORKDIR}"/Omnissa-Horizon-Client-Linux-ClientSDK-${SLOT#*/}-${PV}-*.x64/lib/* "${S}"/usr/lib64/

    # correcting desktop-file
    sed -i 's~Application;Network;~Network;~g' "${S}"/usr/share/applications/omnissa-view.desktop || \
        die "couldn't patch library path"
}

src_install() {
    # installing aplication
    cp -a usr "${D}"

    # installing docs
    dodoc "${WORKDIR}/${P}_docs/"*.txt
    dodoc "${WORKDIR}/${P}_docs/patches/"*
}

pkg_postinst() {
    xdg_desktop_database_update
}

pkg_postrm() {
    xdg_desktop_database_update
}
