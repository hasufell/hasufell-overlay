# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 scons-utils toolchain-funcs git-2 eutils

DESCRIPTION="Flexible Isometric Free Engine"
HOMEPAGE="http://fifengine.de/"
SRC_URI=""

EGIT_REPO_URI="git://github.com/fifengine/fifengine.git"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug +fifechan opengl profile +tinyxml +zip"

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
	media-libs/libpng:0
	x11-libs/libXext
	fifechan? ( >=games-engines/fifechan-0.1.0 )
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	tinyxml? ( >=dev-libs/tinyxml-2.5.3 )"

DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.40:0"

src_prepare() {
	if ! use tinyxml; then
		rm -r ext/tinyxml || die "Removing bundled tinyxml failed."
	fi
	epatch "${FILESDIR}/${P}-unbundle-libpng.patch"
}

src_compile() {
	local myesconsargs=(
		$(usex debug "--enable-debug" "")
		$(usex fifechan "" "--disable-fifechan")
	    $(usex profile "--enable-profile" "")
		$(usex opengl "" "--disable-opengl")
	    $(usex tinyxml "--local-tinyxml" "")
		$(usex zip "" "--disable-zip")
	)
	escons --python-prefix="${D}"$(python_get_sitedir) --prefix="${D}"/usr "$SCONS_ARGS"
}

src_install() {
	scons install-python --python-prefix="${D}/$(python_get_sitedir)" --prefix="${D}/usr"
}
