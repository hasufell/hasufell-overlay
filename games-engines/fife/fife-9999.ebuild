# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 scons-utils toolchain-funcs autotools git-2

DESCRIPTION="Flexible Isometric Free Engine"
HOMEPAGE="http://fifengine.de/"
EGIT_REPO_URI="git://github.com/fifengine/fifengine.git"
SRC_URI=""
LICENSE="LGPL-2.1"

SLOT="0"
IUSE="debug fifechan profile tinyxml opengl atlas"

RDEPEND=">=dev-libs/boost-1.33.1
	>=media-libs/libsdl-1.2.8
	>=media-libs/sdl-ttf-2.0
	>=media-libs/sdl-image-1.2.10[png]
	media-libs/libvorbis
	media-libs/freealut
	media-libs/libogg
	media-libs/openal
	>=sys-libs/zlib-1.2
	x11-libs/libXcursor
	opengl? ( virtual/opengl
			virtual/glu )
	media-libs/libpng
	x11-libs/libXext
	fifechan? ( >=games-engines/fifechan-0.1.0 )
    atlas? ( dev-qt/qtcore:4
			dev-qt/qtgui:4 )
	tinyxml? ( >=dev-libs/tinyxml-2.5.3 )"

DEPEND="${RDEPEND}
	dev-util/scons
	>=dev-lang/swig-1.3.40"

# Compiles only with one thread
#SCONSOPTS="-j1"

src_prepare() {
	if ! use tinyxml; then
		rm -r ext/tinyxml #delete bundled libs
	fi
	epatch "${FILESDIR}/${P}-unbundle-libpng.patch"
}

src_configure() {
	local SCONS_ARGS=""
	if use debug; then
		SCONS_ARGS="$SCONS_ARGS --enable-debug"
	fi
	if use profile; then
		SCONS_ARGS="$SCONS_ARGS --enable-profile"
	fi
	if ! use tinyxml; then
		SCONS_ARGS="$SCONS_ARGS --local-tinyxml"
	fi
	if ! use fifechan; then
		SCONS_ARGS="$SCONS_ARGS --without-fifechan"
	fi
}

src_compile() {
	scons --python-prefix="${D}"/$(python_get_sitedir) --prefix="${D}"/usr "$SCONS_ARGS"
}

src_install() {
	scons install-python --python-prefix="${D}/$(python_get_sitedir)" --prefix="${D}/usr"
}

