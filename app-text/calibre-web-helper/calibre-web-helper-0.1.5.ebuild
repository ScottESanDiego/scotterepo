# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.1
	aho-corasick@1.1.3
	android_system_properties@0.1.5
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.4
	anstyle-wincon@3.0.10
	anstyle@1.0.13
	anyhow@1.0.100
	arbitrary@1.4.2
	autocfg@1.5.0
	bitflags@2.9.4
	block-buffer@0.10.4
	bumpalo@3.19.0
	bytemuck@1.24.0
	byteorder-lite@0.1.0
	cc@1.2.40
	cfg-if@1.0.3
	chrono@0.4.42
	clap@4.5.48
	clap_builder@4.5.48
	clap_derive@4.5.47
	clap_lex@0.7.5
	colorchoice@1.0.4
	core-foundation-sys@0.8.7
	cpufeatures@0.2.17
	crc32fast@1.5.0
	crypto-common@0.1.6
	derive_arbitrary@1.4.2
	deunicode@1.6.2
	digest@0.10.7
	epub@2.1.4
	equivalent@1.0.2
	fallible-iterator@0.3.0
	fallible-streaming-iterator@0.1.9
	find-msvc-tools@0.1.3
	flate2@1.1.3
	foldhash@0.1.5
	generic-array@0.14.7
	getrandom@0.3.3
	hashbrown@0.15.5
	hashbrown@0.16.0
	hashlink@0.10.0
	heck@0.5.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.64
	image@0.25.8
	indexmap@2.11.4
	is_terminal_polyfill@1.70.1
	js-sys@0.3.81
	libc@0.2.176
	libsqlite3-sys@0.35.0
	libz-rs-sys@0.5.2
	log@0.4.28
	memchr@2.7.6
	miniz_oxide@0.8.9
	moxcms@0.7.6
	num-traits@0.2.19
	once_cell@1.21.3
	once_cell_polyfill@1.70.1
	percent-encoding@2.3.2
	pkg-config@0.3.32
	proc-macro2@1.0.101
	pxfm@0.1.24
	quote@1.0.41
	r-efi@5.3.0
	regex-automata@0.4.11
	regex-syntax@0.8.6
	regex@1.11.3
	rusqlite@0.37.0
	rustversion@1.0.22
	same-file@1.0.6
	sha1@0.10.6
	shlex@1.3.0
	simd-adler32@0.3.7
	slug@0.1.6
	smallvec@1.15.1
	strsim@0.11.1
	syn@2.0.106
	thiserror-impl@2.0.17
	thiserror@2.0.17
	typenum@1.19.0
	unicode-ident@1.0.19
	utf8parse@0.2.2
	uuid@1.18.1
	vcpkg@0.2.15
	version_check@0.9.5
	walkdir@2.5.0
	wasi@0.14.7+wasi-0.2.4
	wasip2@1.0.1+wasi-0.2.4
	wasm-bindgen-backend@0.2.104
	wasm-bindgen-macro-support@0.2.104
	wasm-bindgen-macro@0.2.104
	wasm-bindgen-shared@0.2.104
	wasm-bindgen@0.2.104
	winapi-util@0.1.11
	windows-core@0.62.1
	windows-implement@0.60.1
	windows-interface@0.59.2
	windows-link@0.2.0
	windows-result@0.4.0
	windows-strings@0.5.0
	windows-sys@0.60.2
	windows-sys@0.61.1
	windows-targets@0.53.4
	windows_aarch64_gnullvm@0.53.0
	windows_aarch64_msvc@0.53.0
	windows_i686_gnu@0.53.0
	windows_i686_gnullvm@0.53.0
	windows_i686_msvc@0.53.0
	windows_x86_64_gnu@0.53.0
	windows_x86_64_gnullvm@0.53.0
	windows_x86_64_msvc@0.53.0
	wit-bindgen@0.46.0
	xml-rs@0.8.27
	xml-rs@1.0.0
	xml@1.0.0
	zip@3.0.0
	zlib-rs@0.5.2
	zopfli@0.8.2
	zune-core@0.4.12
	zune-jpeg@0.4.21
"

inherit cargo git-r3

DESCRIPTION="CLI tool for manipulating Calibre and Calibre-Web databases"
HOMEPAGE="https://github.com/ScottESanDiego/Calibre-Web-Helper"

# Fetch source code from a specific commit in the GitHub repository
EGIT_REPO_URI="https://github.com/ScottESanDiego/Calibre-Web-Helper.git"
# Specify the exact commit hash to use
EGIT_COMMIT="beb9452536f600af21119937636189f91388779b"

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
}

