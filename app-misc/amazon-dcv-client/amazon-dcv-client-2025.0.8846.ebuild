# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg gnome2-utils

DESCRIPTION="Amazon DCV high-performance remote desktop and application streaming client"
HOMEPAGE="https://www.amazondcv.com/"

# Version components
MY_PV_MAJOR="2025.0"
MY_PV_BUILD="8846"

# Using the RHEL 9 package as the default for Gentoo
SRC_URI="https://d1uj6qtbmh3dt5.cloudfront.net/${MY_PV_MAJOR}/Clients/nice-dcv-viewer-${MY_PV_MAJOR}.${MY_PV_BUILD}-1.el9.x86_64.rpm"

LICENSE="NICE-DCV-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror strip"

# Dependencies determined by ldd on the main binary and bundled library soname checks
# Note: Most libraries are bundled; these are system libraries required
RDEPEND="
	app-arch/bzip2
	app-arch/libdeflate
	app-crypt/mit-krb5
	app-crypt/p11-kit
	dev-libs/gmp
	dev-libs/icu
	dev-libs/libthai
	dev-libs/libtasn1
	dev-libs/libunistring
	dev-libs/libxml2
	dev-libs/nettle
	media-gfx/graphite2
	media-libs/jbigkit
	media-libs/lerc
	media-libs/libpng
	media-libs/libwebp
	media-libs/vulkan-loader
	net-dns/libidn2
	net-libs/gnutls
	net-print/cups
	sys-apps/util-linux
	sys-libs/libselinux
	sys-libs/libunwind
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libxkbcommon
"

BDEPEND="app-arch/libarchive"

S="${WORKDIR}"

QA_PREBUILT="*"

# Suppress QA warnings for bundled libraries without proper SONAME symlinks
# Note: This does NOT suppress "Unresolved soname dependencies" warnings, which are expected
# for bundled Ubuntu libraries (libfreetype, libharfbuzz-icu, libtiff) that reference
# specific Ubuntu library versions. These warnings are harmless - the dynamic linker will
# find compatible Gentoo library versions at runtime.
QA_SONAME="
	usr/lib.*/dcvviewer/.*
"

src_unpack() {
	bsdtar -xf "${DISTDIR}/${A}" -C "${S}" || die "Failed to unpack RPM"
}

src_prepare() {
	default

	local rpm_root="."
	if [[ ! -d usr ]]; then
		local candidates=(*/usr)
		if [[ -d "${candidates[0]}" ]]; then
			rpm_root="${candidates[0]%/usr}"
		fi
	fi

	# Patch wrapper script to use Gentoo's library paths if needed
	if [[ -f ${rpm_root}/usr/bin/dcvviewer ]]; then
		sed -i \
			-e "s|lib/x86_64-linux-gnu|$(get_libdir)|g" \
			"${rpm_root}/usr/bin/dcvviewer" || die "Failed to patch wrapper script"
	fi

	# Patch WebRTC extension manifest to use Gentoo's library paths (if present)
	if [[ -f ${rpm_root}/usr/share/dcvviewer/extensions/com.amazon.dcv.webrtc.extension.manifest.json ]]; then
		sed -i \
			-e "s|/usr/lib/x86_64-linux-gnu|/usr/$(get_libdir)|g" \
			"${rpm_root}/usr/share/dcvviewer/extensions/com.amazon.dcv.webrtc.extension.manifest.json" \
			|| die "Failed to patch WebRTC extension manifest"
	fi
}

src_install() {
	local rpm_root="."
	if [[ ! -d usr ]]; then
		local candidates=(*/usr)
		if [[ -d "${candidates[0]}" ]]; then
			rpm_root="${candidates[0]%/usr}"
		fi
	fi

	# Install wrapper script
	dobin "${rpm_root}/usr/bin/dcvviewer"

	# Install bundled libraries and application files
	insinto /usr/$(get_libdir)
	doins -r "${rpm_root}/usr/$(get_libdir)/dcvviewer"

	# Make bundled binaries executable
	exeinto /usr/libexec/dcvviewer
	doexe "${rpm_root}"/usr/libexec/dcvviewer/{dcvviewer,dcvextensionswatchdog}
	doexe "${rpm_root}"/usr/libexec/dcvviewer/{gdk-pixbuf-query-loaders,glib-compile-resources,glib-compile-schemas}
	doexe "${rpm_root}"/usr/libexec/dcvviewer/{gst-plugin-scanner,gtk4-update-icon-cache}

	# Provide libjbig.so.0 via system libjbig.so
	dosym /usr/$(get_libdir)/libjbig.so /usr/$(get_libdir)/dcvviewer/libjbig.so.0

	# Prefer system harfbuzz-icu to match Gentoo ICU versions
	dosym /usr/$(get_libdir)/libharfbuzz-icu.so.0 /usr/$(get_libdir)/dcvviewer/libharfbuzz-icu.so.0

	# Install shared data
	insinto /usr/share
	doins -r "${rpm_root}"/usr/share/{dcvviewer,glib-2.0,icons,locale,metainfo,mime}

	# Install desktop file
	domenu "${rpm_root}"/usr/share/applications/*.desktop

	# Install documentation
	dodoc "${rpm_root}"/usr/share/dcvviewer/license/EULA.txt
	dodoc "${rpm_root}"/usr/share/dcvviewer/third-party-licenses.txt
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	# Generate gdk-pixbuf loaders cache with real install paths
	local pixbuf_dir="/usr/$(get_libdir)/dcvviewer/gdk-pixbuf-2.0/2.10.0"
	local pixbuf_modules="${pixbuf_dir}/loaders"
	LD_LIBRARY_PATH="/usr/$(get_libdir)/dcvviewer:${LD_LIBRARY_PATH}" \
	GDK_PIXBUF_MODULEDIR="${pixbuf_modules}" \
		/usr/libexec/dcvviewer/gdk-pixbuf-query-loaders \
		> "${pixbuf_dir}/loaders.cache" || elog "Failed to generate gdk-pixbuf loaders cache"

	elog "Amazon DCV Client has been installed."
	elog ""
	elog "By installing this package, you accept the Amazon DCV End User License Agreement (EULA)."
	elog "See: https://www.amazondcv.com/license.html"
	elog ""
	elog "You can start the DCV Viewer by running 'dcvviewer' or from your application menu."
	elog ""
	elog "Note: QA warnings about unresolved soname dependencies for bundled libraries"
	elog "(libfreetype, libharfbuzz-icu, libtiff) are expected. These libraries were"
	elog "compiled on Ubuntu and reference specific library versions. The dynamic linker"
	elog "will use compatible Gentoo library versions at runtime."
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
