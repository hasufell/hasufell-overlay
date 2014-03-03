# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WX_GTK_VER="3.0"

inherit cmake-utils eutils git-2 gnome2-utils wxwidgets toolchain-funcs games

# tools versions
BREAKPAD_ARC="breakpad-850-r1.zip"
CEF_ARC="cef-291.tar.gz"
V8_ARC="v8-3.18.5.14.tar.bz2"
WX_ARC="wxWidgets-3.0.0.tar.bz2"

DESCRIPTION="Free software version of Desura game client"
HOMEPAGE="http://desura.com https://github.com/lindenlab/desura-app"
SRC_URI="https://s3-us-west-2.amazonaws.com/lecs.desura.lindenlab.com/${BREAKPAD_ARC}
	https://s3-us-west-2.amazonaws.com/lecs.desura.lindenlab.com/${CEF_ARC}
	https://s3-us-west-2.amazonaws.com/lecs.desura.lindenlab.com/${V8_ARC}
	bundled-wxgtk? ( mirror://sourceforge/wxwindows/${WX_ARC} )"

EGIT_REPO_URI="https://github.com/lindenlab/desura-app.git git://github.com/lindenlab/desura-app.git"
EGIT_NOUNPACK="true"

# breakpad, cef, v8: BSD
LICENSE="LGPL-2.1 BSD bundled-wxgtk? ( wxWinLL-3 GPL-2 )"
SLOT="0"
KEYWORDS=""
IUSE="+32bit bundled-wxgtk debug tools"

# TODO: clang useflag should be substituted
COMMON_DEPEND="
	app-arch/bzip2
	dev-cpp/gtest
	dev-db/sqlite
	>=dev-libs/boost-1.47:=
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/tinyxml2
	|| (
		net-misc/curl[adns]
		net-misc/curl[ares]
	)
	media-libs/libpng:0
	media-libs/tiff
	net-libs/webkit-gtk:2
	net-misc/curl
	>=sys-devel/gcc-4.6.0
	sys-libs/zlib
	virtual/jpeg
	x11-libs/gtk+:2
	x11-libs/libnotify
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXxf86vm
	!bundled-wxgtk? (
		x11-libs/wxGTK:${WX_GTK_VER}[X]
	)
	amd64? ( 32bit? ( >=sys-devel/gcc-4.6.0[multilib] ) )"
RDEPEND="${COMMON_DEPEND}
	=media-libs/desurium-cef-9999*
	x11-misc/xdg-user-dirs
	x11-misc/xdg-utils"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(tc-getCC) =~ gcc ]]; then
			if [[ $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 6 || $(gcc-major-version) -lt 4 ]] ; then
				eerror "You need at least sys-devel/gcc-4.6.0"
				die "You need at least sys-devel/gcc-4.6.0"
			fi
		fi
	fi
}

src_unpack() {
	git-2_src_unpack
}

src_configure() {
	local mycmakeargs=(
		-DFORCE_SYS_DEPS=TRUE
		-DBUILD_CEF=FALSE
		-BUILD_ONLY_CEF=FALSE
		$(cmake-utils_use debug DEBUG)
		$(cmake-utils_use 32bit 32BIT_SUPPORT)
		$(cmake-utils_use tools BUILD_TOOLS)
		-DWITH_FLASH=FALSE
		-DCMAKE_INSTALL_PREFIX="${GAMES_PREFIX}"
		-DBREAKPAD_URL="file://${DISTDIR}/${BREAKPAD_ARC}"
		-DCEF_URL="file://${DISTDIR}/${CEF_ARC}"
		-DV8_URL="file://${DISTDIR}/${V8_ARC}"
		-DBINDIR="${GAMES_BINDIR}"
		-DDATADIR="${GAMES_DATADIR}"
		-DRUNTIME_LIBDIR="$(games_get_libdir)"
		-DDESKTOPDIR="/usr/share/applications"
		$(use bundled-wxgtk && echo -DWXWIDGET_URL="file://${DISTDIR}/${WX_ARC}")
		$(cmake-utils_use bundled-wxgtk FORCE_BUNDLED_WXGTK)
	)
	cmake-utils_src_configure
}

src_compile() {
	# fix parallel make
	# https://github.com/lindenlab/desura-app/issues/795
	if use bundled-wxgtk ; then
		# even autotools does not respect AR properly sometimes
		cmake-utils_src_compile AR="$(tc-getAR)" wxWidgets
	fi

	# override games LD export which breaks the build
	cmake-utils_src_compile LD="$(tc-getCXX)" AR="$(tc-getAR)"
}

src_install() {
	cmake-utils_src_install

	newicon -s scalable "${S}"/src/branding_${PN}/sources/desubot.svg ${PN}.svg
	make_desktop_entry desura Desurium

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
