# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Omnissa Horizon Client for Linux"
HOMEPAGE="https://www.omnissa.com/products/horizon-8/ https://customerconnect.omnissa.com/downloads/info/slug/virtual_desktop_and_apps/omnissa_horizon_clients/8"

VER1="CART26FQ4_LIN_2512"
VER2="8.17.0-20187591429"

SRC_URI="https://download3.omnissa.com/software/${VER1}_TARBALL/Omnissa-Horizon-Client-Linux-${PV}-${VER2}.tar.gz"

S="${WORKDIR}"

LICENSE="omnissa"
SLOT="0"
KEYWORDS="~amd64"
IUSE="forcetheme systemd usb wayland"
RESTRICT="mirror"

inherit systemd xdg

RDEPEND="
	dev-cpp/gtkmm:3.0[wayland?]
	dev-libs/libxml2-compat
	dev-util/lttng-ust-compat
	media-libs/libjpeg-turbo
	media-libs/libva-compat
	media-libs/libva[X,wayland?]
	x11-libs/libvdpau
	usb? ( virtual/libusb:1 )
	wayland? ( dev-libs/wayland )
"

# Pre-built binaries
QA_PREBUILT="
	usr/lib64/omnissa/*
	usr/lib64/pcoip/*
	usr/lib64/libpcoip_client.so
	usr/lib64/libclientSdkCPrimitive.so
"

src_unpack() {
	unpack "Omnissa-Horizon-Client-Linux-${PV}-${VER2}.tar.gz"
	unpack "Omnissa-Horizon-Client-Linux-${PV}-${VER2}/x64/Omnissa-Horizon-Client-${PV}-${VER2}.x64.tar.gz"
	unpack "Omnissa-Horizon-Client-Linux-${PV}-${VER2}/x64/Omnissa-Horizon-PCoIP-${PV}-${VER2}.x64.tar.gz"

	if use usb; then
		unpack "Omnissa-Horizon-Client-Linux-${PV}-${VER2}/x64/Omnissa-Horizon-USB-${PV}-${VER2}.x64.tar.gz"
		unpack "Omnissa-Horizon-Client-Linux-${PV}-${VER2}/x64/Omnissa-Horizon-scannerClient-${PV}-${VER2}.x64.tar.gz"
		unpack "Omnissa-Horizon-Client-Linux-${PV}-${VER2}/x64/Omnissa-Horizon-serialportClient-${PV}-${VER2}.x64.tar.gz"
	fi
}

src_prepare() {
	cd "${WORKDIR}"/Omnissa-Horizon-Client-"${PV}"-"${VER2}".x64
	# Patch lib dir
	sed -i 's:/usr/lib/:/usr/lib64/:g' usr/bin/*

	# Fix deprecated "Application" category in desktop files
	sed -i 's/Categories=Application;Network;/Categories=Network;/' usr/share/applications/*.desktop

	if use forcetheme; then
		sed -i \
			-e 's#^Exec=horizon-client #Exec=env GTK_THEME=Materia horizon-client #' \
			-e 's#^Exec=/usr/bin/horizon-client #Exec=env GTK_THEME=Materia /usr/bin/horizon-client #' \
			usr/share/applications/*.desktop
	fi

	eapply_user
}

src_install() {
	cd "${WORKDIR}"/Omnissa-Horizon-Client-"${PV}"-"${VER2}".x64/usr

	for binfile in bin/*; do
		dobin "${binfile}"
	done

	insinto /usr/lib64
	doins lib/libclientSdkCPrimitive.so
	doins -r lib/omnissa

	# Fix execute permissions for binaries
	exeinto /usr/lib64/omnissa/horizon/bin/
	doexe lib/omnissa/horizon/bin/horizon-client

	# Fix execute permissions in horizon-client-next-bundle
	exeinto /usr/lib64/omnissa/horizon/bin/horizon-client-next-bundle
	doexe lib/omnissa/horizon/bin/horizon-client-next-bundle/horizon-client-next
	doexe lib/omnissa/horizon/bin/horizon-client-next-bundle/createdump
	doexe lib/omnissa/horizon/bin/horizon-client-next-bundle/install_client_sdk.sh
	doexe lib/omnissa/horizon/bin/horizon-client-next-bundle/*.so

	# Other binaries
	exeinto /usr/lib64/omnissa/horizon/bin/
	doexe lib/omnissa/horizon/bin/horizon-urlFilter
	doexe lib/omnissa/horizon/bin/horizon_url_native_host

	insinto /usr/share
	doins -r share/applications
	doins -r share/icons
	doins -r share/locale
	doins -r share/pixmaps
	#doins -r share/X11

	dodoc -r share/doc

	cd "${WORKDIR}"/Omnissa-Horizon-PCoIP-"${PV}"-"${VER2}".x64/usr
	insinto /usr/lib64
	doins lib/libpcoip_client.so
	doins -r lib/omnissa
	doins -r lib/pcoip

	exeinto /usr/lib64/omnissa/horizon/client
	doexe lib/omnissa/horizon/client/horizon-protocol

	if use usb; then
		cd "${WORKDIR}"/Omnissa-Horizon-USB-"${PV}"-"${VER2}".x64/usr
		insinto /usr/lib64
		doins -r lib/omnissa

		exeinto /usr/lib64/omnissa/horizon/usb
		doexe lib/omnissa/horizon/usb/horizon-eucusbarbitrator

		# Create symlink for USB arbitrator in /usr/bin
		dosym ../lib64/omnissa/horizon/usb/horizon-eucusbarbitrator /usr/bin/horizon-eucusbarbitrator

		# Install scanner support (required for USB redirection)
		cd "${WORKDIR}"/Omnissa-Horizon-scannerClient-"${PV}"-"${VER2}".x64/usr
		insinto /usr/lib64
		doins -r lib/omnissa

		exeinto /usr/lib64/omnissa/horizon/bin
		doexe lib/omnissa/horizon/bin/ftscanhvd

		# Install scanner config
		insinto /etc/omnissa
		doins "${WORKDIR}"/Omnissa-Horizon-scannerClient-"${PV}"-"${VER2}".x64/etc/omnissa/ftplugins.conf

		# Install serial port support (ftsprhvd)
		cd "${WORKDIR}"/Omnissa-Horizon-serialportClient-"${PV}"-"${VER2}".x64/usr
		insinto /usr/lib64
		doins -r lib/omnissa

		exeinto /usr/lib64/omnissa/horizon/bin
		doexe lib/omnissa/horizon/bin/ftsprhvd

		# Install init/service files
		if use systemd; then
			systemd_dounit "${FILESDIR}"/horizon-usbarbitrator.service
			systemd_dounit "${FILESDIR}"/horizon-ftscanhvd.service
			systemd_dounit "${FILESDIR}"/horizon-ftsprhvd.service
		else
			newinitd "${FILESDIR}"/horizon-usbarbitrator.initd horizon-usbarbitrator
			newinitd "${FILESDIR}"/horizon-ftscanhvd.initd horizon-ftscanhvd
			newinitd "${FILESDIR}"/horizon-ftsprhvd.initd horizon-ftsprhvd
		fi
	fi

	# Fix permissions on all shared libraries
	find "${ED}"/usr/lib64/omnissa -name "*.so*" -type f -exec chmod 755 {} \; || die
	find "${ED}"/usr/lib64/pcoip -name "*.so*" -type f -exec chmod 755 {} \; 2>/dev/null || true
	chmod 755 "${ED}"/usr/lib64/libclientSdkCPrimitive.so || die
	chmod 755 "${ED}"/usr/lib64/libpcoip_client.so || die

	# Create symlinks for hardcoded /usr/lib paths in binaries
	dosym ../lib64/omnissa /usr/lib/omnissa
	dosym ../lib64/pcoip /usr/lib/pcoip
	dosym ../lib64/libclientSdkCPrimitive.so /usr/lib/libclientSdkCPrimitive.so
	dosym ../lib64/libpcoip_client.so /usr/lib/libpcoip_client.so
}
