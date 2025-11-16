# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.4
	anstyle-wincon@3.0.10
	anstyle@1.0.13
	bitflags@2.10.0
	block2@0.6.2
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	clap@4.5.51
	clap_builder@4.5.51
	clap_derive@4.5.49
	clap_lex@0.7.6
	colorchoice@1.0.4
	ctrlc@3.5.1
	directories@6.0.0
	dirs-sys@0.5.0
	dispatch2@0.3.0
	equivalent@1.0.2
	getrandom@0.2.16
	hashbrown@0.16.0
	heck@0.5.0
	indexmap@2.12.0
	is_terminal_polyfill@1.70.2
	itoa@1.0.15
	libc@0.2.177
	libredox@0.1.10
	memchr@2.7.6
	nix@0.30.1
	objc2-encode@4.1.0
	objc2@0.6.3
	once_cell_polyfill@1.70.2
	option-ext@0.2.0
	proc-macro2@1.0.103
	quote@1.0.42
	redox_users@0.5.2
	ryu@1.0.20
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	serde_spanned@1.0.3
	strsim@0.11.1
	syn@2.0.110
	thiserror-impl@2.0.17
	thiserror@2.0.17
	toml@0.9.8
	toml_datetime@0.7.3
	toml_parser@1.0.4
	toml_writer@1.0.4
	unicode-ident@1.0.22
	utf8parse@0.2.2
	wasi@0.11.1+wasi-snapshot-preview1
	windows-link@0.2.1
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.53.1
	winnow@0.7.13
"

inherit cargo git-r3

DESCRIPTION="A simple fan control daemon written in Rust"
HOMEPAGE="https://github.com/ScottESanDiego/rustyfan"

# Fetch source code from a specific commit in the GitHub repository
EGIT_REPO_URI="https://github.com/ScottESanDiego/rustyfan.git"
# Specify the exact commit hash to use
EGIT_COMMIT="c2c774d13971e383cba529cc338c4352f2cb21fa"

SRC_URI="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	MIT MPL-2.0 Unicode-3.0
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64"

# Dependencies:
# Build-time: dev-lang/rust (handled by cargo eclass)
# Runtime: None explicitly, relies on kernel hwmon/thermal interfaces
#          virtual/logger for elog logging in init script (if used by upstream script)
#          sys-apps/baselayout-openrc or sys-apps/openrc for OpenRC support
DEPEND="virtual/logger"

# Use the standard working directory layout for git-r3
# The version part of S needs to match the ebuild version (0_p20231120)
# git-r3 handles the source directory naming correctly based on PV
#S="${WORKDIR}/${PN}-${PV}" # PV will be 0_p20231120

# src_compile is handled by cargo_src_compile from the cargo eclass

src_unpack() {
	git-r3_src_unpack
	cargo_src_unpack
}

src_prepare() {
	cargo_gen_config
	default
}

src_install() {
	# Install the main binary using the cargo eclass helper
	# This installs to /usr/bin/${PN} by default
	cargo_src_install

    # Install the OpenRC init script provided by upstream
    # The script is located at init.d/rustyfan in the source directory
    # newinitd installs the script to /etc/init.d/${PN}
    newinitd "${S}/init.d/${PN}" "${PN}"

    # Install the example configuration file
    # Create the target directory /etc/rustyfan
    keepdir /etc/${PN}
	#
    # Install the config file from the source directory into /etc/rustyfan/
    # Rename it to config.toml.example to indicate it's an example
    insinto /etc/${PN}
    newins "${S}/etc/config.toml.example" config.toml.example
}

pkg_postinst() {
        # Display messages after installation to guide the user

        # Inform about the configuration file location and required action
       elog "An example configuration file has been installed to:"
       elog "/etc/${PN}/config.toml.example"
       elog "Please copy and edit it to /etc/${PN}/config.toml to configure rustyfan."
       elog "The service will likely fail to start without a valid configuration."
}
