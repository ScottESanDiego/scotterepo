# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.1
	aho-corasick@1.1.4
	android_system_properties@0.1.5
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.102
	arbitrary@1.4.2
	autocfg@1.5.0
	bitflags@2.11.0
	block-buffer@0.12.0
	bumpalo@3.20.2
	bytemuck@1.25.0
	byteorder-lite@0.1.0
	cc@1.2.59
	cfg-if@1.0.4
	chrono@0.4.44
	clap@4.6.0
	clap_builder@4.6.0
	clap_derive@4.6.0
	clap_lex@1.1.0
	colorchoice@1.0.5
	const-oid@0.10.2
	core-foundation-sys@0.8.7
	cpufeatures@0.3.0
	crc32fast@1.5.0
	crypto-common@0.2.1
	derive_arbitrary@1.4.2
	digest@0.11.2
	epub@2.1.5
	equivalent@1.0.2
	fallible-iterator@0.3.0
	fallible-streaming-iterator@0.1.9
	find-msvc-tools@0.1.9
	flate2@1.1.9
	foldhash@0.1.5
	foldhash@0.2.0
	getrandom@0.4.2
	hashbrown@0.15.5
	hashbrown@0.16.1
	hashbrown@0.17.0
	hashlink@0.11.0
	heck@0.5.0
	hybrid-array@0.4.10
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	id-arena@2.3.0
	image@0.25.10
	indexmap@2.14.0
	is_terminal_polyfill@1.70.2
	itoa@1.0.18
	js-sys@0.3.94
	leb128fmt@0.1.0
	libc@0.2.184
	libsqlite3-sys@0.37.0
	log@0.4.29
	memchr@2.8.0
	miniz_oxide@0.8.9
	moxcms@0.8.1
	num-traits@0.2.19
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	percent-encoding@2.3.2
	pkg-config@0.3.32
	prettyplease@0.2.37
	proc-macro2@1.0.106
	pxfm@0.1.28
	quote@1.0.45
	r-efi@6.0.0
	regex-automata@0.4.14
	regex-syntax@0.8.10
	regex@1.12.3
	rsqlite-vfs@0.1.0
	rusqlite@0.39.0
	rustversion@1.0.22
	same-file@1.0.6
	semver@1.0.28
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	sha1@0.11.0
	shlex@1.3.0
	simd-adler32@0.3.9
	smallvec@1.15.1
	sqlite-wasm-rs@0.5.2
	strsim@0.11.1
	syn@2.0.117
	thiserror-impl@2.0.18
	thiserror@2.0.18
	typenum@1.19.0
	unicode-ident@1.0.24
	unicode-xid@0.2.6
	utf8parse@0.2.2
	uuid@1.23.0
	vcpkg@0.2.15
	walkdir@2.5.0
	wasip2@1.0.2+wasi-0.2.9
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-bindgen-macro-support@0.2.117
	wasm-bindgen-macro@0.2.117
	wasm-bindgen-shared@0.2.117
	wasm-bindgen@0.2.117
	wasm-encoder@0.244.0
	wasm-metadata@0.244.0
	wasmparser@0.244.0
	winapi-util@0.1.11
	windows-core@0.62.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.61.2
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.51.0
	wit-component@0.244.0
	wit-parser@0.244.0
	xml-rs@1.0.0
	xml@1.2.1
	zip@3.0.0
	zlib-rs@0.6.3
	zmij@1.0.21
	zopfli@0.8.3
	zune-core@0.5.1
	zune-jpeg@0.5.15
"

inherit cargo git-r3

DESCRIPTION="CLI tool for manipulating Calibre and Calibre-Web databases"
HOMEPAGE="https://github.com/ScottESanDiego/Calibre-Web-Helper"

# Fetch source code from a specific commit in the GitHub repository
EGIT_REPO_URI="https://github.com/ScottESanDiego/Calibre-Web-Helper.git"
# Specify the exact commit hash to use
EGIT_COMMIT="69db9461e5d5262b40be674a8fa00dc1f4432130"

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

