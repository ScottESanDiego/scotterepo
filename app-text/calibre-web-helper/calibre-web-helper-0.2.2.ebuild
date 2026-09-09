# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.98.1"

CRATES="
	adler2@2.0.1
	aho-corasick@1.1.5
	android_system_properties@0.1.6
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.104
	autocfg@1.5.1
	bitflags@2.13.1
	block-buffer@0.12.1
	bumpalo@3.20.3
	bytemuck@1.25.2
	byteorder-lite@0.1.0
	cc@1.4.5
	cfg-if@1.0.4
	chrono@0.4.45
	clap@4.6.6
	clap_builder@4.6.6
	clap_derive@4.6.4
	clap_lex@1.1.0
	colorchoice@1.0.5
	const-oid@0.10.2
	core-foundation-sys@0.8.7
	cpufeatures@0.3.1
	crc32fast@1.5.1
	crypto-common@0.2.2
	digest@0.11.3
	equivalent@1.0.2
	fallible-iterator@0.3.0
	fallible-streaming-iterator@0.1.9
	fdeflate@0.3.7
	find-msvc-tools@0.1.12
	flate2@1.1.10
	futures-core@0.3.34
	futures-task@0.3.34
	futures-util@0.3.34
	getrandom@0.4.3
	hashbrown@0.17.1
	heck@0.5.0
	hybrid-array@0.4.15
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	image-webp@0.2.4
	image@0.25.10
	indexmap@2.14.2
	is_terminal_polyfill@1.70.2
	js-sys@0.3.105
	libc@0.2.189
	libsqlite3-sys@0.38.2
	log@0.4.34
	memchr@2.8.3
	miniz_oxide@0.8.9
	miniz_oxide@0.9.1
	moxcms@0.8.1
	num-traits@0.2.19
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	percent-encoding@2.3.2
	pin-project-lite@0.2.17
	pkg-config@0.3.34
	png@0.18.1
	proc-macro2@1.0.107
	pxfm@0.1.30
	quick-error@2.0.1
	quick-xml@0.41.0
	quote@1.0.47
	r-efi@6.0.0
	rbook@0.7.10
	regex-automata@0.4.18
	regex-syntax@0.8.11
	regex@1.13.1
	rusqlite@0.40.2
	rustversion@1.0.23
	same-file@1.0.6
	sha2@0.11.0
	shlex@2.0.1
	simd-adler32@0.3.10
	slab@0.4.12
	smallvec@1.16.0
	strsim@0.11.1
	syn@2.0.119
	syn@3.0.5
	thiserror-impl@2.0.20
	thiserror@2.0.20
	typed-path@0.12.3
	typenum@1.20.1
	unicode-ident@1.0.24
	utf8parse@0.2.2
	uuid@1.26.0
	vcpkg@0.2.15
	walkdir@2.5.0
	wasm-bindgen-macro-support@0.2.128
	wasm-bindgen-macro@0.2.128
	wasm-bindgen-shared@0.2.128
	wasm-bindgen@0.2.128
	winapi-util@0.1.11
	windows-core@0.62.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.61.2
	zip@8.6.0
	zlib-rs@0.6.7
	zune-core@0.5.3
	zune-jpeg@0.5.15
"

inherit cargo

DESCRIPTION="CLI tool for managing Calibre and Calibre-Web libraries"
HOMEPAGE="https://github.com/ScottESanDiego/Calibre-Web-Helper"
SRC_URI="
	https://github.com/ScottESanDiego/Calibre-Web-Helper/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}/Calibre-Web-Helper-${PV}"

LICENSE="BSD-2"
# Dependent crate licenses
LICENSE+=" 0BSD Apache-2.0 BSD MIT Unicode-3.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( README.md )

src_configure() {
	cargo_src_configure --locked
}

src_install() {
	cargo_src_install
	einstalldocs
}
