# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 )

inherit check-reqs cmake-utils git-2 python-any-r1 games

# tools versions
CEF_ARC="cef-291.tar.gz"
CHROMIUM_ARC="chromium-15.0.876.0.tar.bz2"
DEPOT_TOOLS_ARC="depot_tools-145556-2.tar.gz"

DESCRIPTION="Highly patched CEF by desurium"
HOMEPAGE="https://github.com/lodle/Desurium"
SRC_URI="mirror://github/lodle/Desurium/${CEF_ARC}
	http://commondatastorage.googleapis.com/chromium-browser-official/${CHROMIUM_ARC}
	mirror://github/lodle/Desurium/${DEPOT_TOOLS_ARC}"

EGIT_REPO_URI="git://github.com/lodle/Desurium.git"
EGIT_NOUNPACK="true"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
RESTRICT="bindist"

COMMON_DEPEND="
	app-arch/bzip2
	dev-libs/dbus-glib
	dev-libs/libevent
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/flac
	media-libs/libpng:0
	media-libs/libwebp
	media-libs/speex
	sys-apps/dbus
	sys-libs/zlib
	virtual/jpeg
	x11-libs/gtk+:2"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	dev-lang/yasm
	dev-util/gperf
	virtual/pkgconfig"

CHECKREQS_DISK_BUILD="3G"

pkg_setup() {
	python-any-r1_pkg_setup
	games_pkg_setup
}

src_unpack() {
	git-2_src_unpack
}

src_configure() {
	local mycmakeargs=(
		-DFORCE_SYS_DEPS=TRUE
		-DCMAKE_INSTALL_PREFIX="${GAMES_PREFIX}"
		-DCEF_URL="file://${DISTDIR}/${CEF_ARC}"
		-DCHROMIUM_URL="file://${DISTDIR}/${CHROMIUM_ARC}"
		-DDEPOT_TOOLS_URL="file://${DISTDIR}/${DEPOT_TOOLS_ARC}"
		-DBUILD_ONLY_CEF=TRUE
		-DRUNTIME_LIBDIR="$(games_get_libdir)"
		-DH264_SUPPORT=TRUE
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}
