# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.4
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	bitflags@2.11.0
	block2@0.6.2
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	clap@4.6.0
	clap_builder@4.6.0
	clap_derive@4.6.0
	clap_lex@1.1.0
	colorchoice@1.0.5
	ctrlc@3.5.2
	directories@6.0.0
	dirs-sys@0.5.0
	dispatch2@0.3.1
	equivalent@1.0.2
	getrandom@0.2.17
	hashbrown@0.16.1
	heck@0.5.0
	indexmap@2.13.0
	is_terminal_polyfill@1.70.2
	itoa@1.0.17
	lazy_static@1.5.0
	libc@0.2.183
	libredox@0.1.14
	log@0.4.29
	matchers@0.2.0
	memchr@2.8.0
	nix@0.31.2
	nu-ansi-term@0.50.3
	objc2-encode@4.1.0
	objc2@0.6.4
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	option-ext@0.2.0
	pin-project-lite@0.2.17
	proc-macro2@1.0.106
	quote@1.0.45
	redox_users@0.5.2
	regex-automata@0.4.14
	regex-syntax@0.8.10
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	serde_spanned@1.0.4
	sharded-slab@0.1.7
	smallvec@1.15.1
	strsim@0.11.1
	syn@2.0.117
	thiserror-impl@2.0.18
	thiserror@2.0.18
	thread_local@1.1.9
	toml@1.0.6+spec-1.1.0
	toml_datetime@1.0.0+spec-1.1.0
	toml_parser@1.0.9+spec-1.1.0
	toml_writer@1.0.6+spec-1.1.0
	tracing-attributes@0.1.31
	tracing-core@0.1.36
	tracing-log@0.2.0
	tracing-subscriber@0.3.23
	tracing@0.1.44
	unicode-ident@1.0.24
	utf8parse@0.2.2
	valuable@0.1.1
	wasi@0.11.1+wasi-snapshot-preview1
	windows-link@0.2.1
	windows-sys@0.61.2
	winnow@0.7.15
	zmij@1.0.21
"

inherit cargo git-r3

DESCRIPTION="A simple fan control daemon written in Rust"
HOMEPAGE="https://github.com/ScottESanDiego/rustyfan"

# Fetch source code from a specific commit in the GitHub repository
EGIT_REPO_URI="https://github.com/ScottESanDiego/rustyfan.git"
# Specify the exact commit hash to use
EGIT_COMMIT="ee24def8148990645fad8a3c0f5b453a8409bc90"

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
