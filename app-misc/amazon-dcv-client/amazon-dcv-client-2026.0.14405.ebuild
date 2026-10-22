# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RPM_COMPRESS_TYPE=zstd
inherit desktop gnome2-utils rpm xdg

DESCRIPTION="Amazon DCV high-performance remote desktop and application streaming client"
HOMEPAGE="https://www.amazondcv.com/"
MY_PV=$(ver_cut 1-2)
MY_BUILD=$(ver_cut 3)
BASE_URI="https://d1uj6qtbmh3dt5.cloudfront.net/${MY_PV}/Clients"
SRC_URI="${BASE_URI}/nice-dcv-viewer-${MY_PV}.${MY_BUILD}-1.el9.x86_64.rpm"
S=${WORKDIR}

# Includes the licenses listed in the vendor third-party notices.
LICENSE="NICE-DCV-EULA 0BSD Apache-2.0 BSD BSD-2 FTL IJG ISC
	LGPL-2 LGPL-2.1 LGPL-3 MIT MPL-2.0 OPENLDAP openssl
	Unicode-3.0 ZLIB libtiff"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror strip"

# The bundled GTK4 sink requires GstGL's X11 and EGL entry points even
# when the viewer runs under Wayland. Either GL API provides GstGL.
RDEPEND="
	app-arch/brotli
	app-arch/bzip2
	app-arch/xz-utils
	app-arch/zstd
	app-crypt/mit-krb5
	dev-libs/libgudev
	dev-libs/libpcre2
	|| (
		dev-libs/libxml2-compat:2
		<dev-libs/libxml2-2.14:2
	)
	dev-libs/libthai
	dev-libs/openssl:0/3
	|| (
		media-libs/gst-plugins-base:1.0[X,egl,gles2]
		media-libs/gst-plugins-base:1.0[X,egl,opengl]
	)
	media-libs/harfbuzz[icu]
	media-libs/libpng:0/16
	media-libs/libpulse
	media-libs/libva[X]
	net-print/cups
	sys-apps/pcsc-lite
	sys-devel/gcc:*
	sys-fs/e2fsprogs
	sys-libs/libselinux
	sys-libs/libxcrypt
	virtual/libudev
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libxkbcommon
"

QA_PREBUILT="*"
# Vendor modules loaded by filename do not have SONAMEs.
QA_SONAME="
	usr/lib.*/dcvviewer/gio/modules/libgiolibproxy\.so
	usr/lib.*/dcvviewer/liblmdb\.so
"

pkg_pretend() {
	use elibc_glibc || die "Amazon DCV requires glibc"
}

src_install() {
	dobin usr/bin/dcvviewer

	insinto /usr/$(get_libdir)
	doins -r usr/$(get_libdir)/dcvviewer

	# Avoid mixing incompatible vendor and system library variants.
	rm "${ED}"/usr/$(get_libdir)/dcvviewer/{libharfbuzz-icu.so.0,libpcre2-8.so.0} || die
	dosym -r \
		"/usr/$(get_libdir)/libpcre2-8.so.0" \
		"/usr/$(get_libdir)/dcvviewer/libpcre2-8.so.0"
	dosym -r "/usr/$(get_libdir)/libharfbuzz-icu.so.0" \
		"/usr/$(get_libdir)/dcvviewer/libharfbuzz-icu.so.0"

	exeinto /usr/libexec/dcvviewer
	doexe usr/libexec/dcvviewer/*

	insinto /usr/share
	doins -r usr/share/{dcvviewer,glib-2.0,icons,locale,metainfo,mime}
	domenu usr/share/applications/*.desktop

	local libdir="/usr/$(get_libdir)/dcvviewer"
	local pixbuf_dir="${libdir}/gdk-pixbuf-2.0/2.10.0"
	LD_LIBRARY_PATH="${ED}${libdir}" \
	GDK_PIXBUF_MODULEDIR="${ED}${pixbuf_dir}/loaders" \
		"${ED}/usr/libexec/dcvviewer/gdk-pixbuf-query-loaders" \
		> "${T}/loaders.cache" || die "Failed to generate gdk-pixbuf loader cache"
	sed "s#${ED}##g" "${T}/loaders.cache" \
		> "${ED}${pixbuf_dir}/loaders.cache" || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	elog "By installing this package, you accept the Amazon DCV EULA:"
	elog "https://www.amazondcv.com/license.html"
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
