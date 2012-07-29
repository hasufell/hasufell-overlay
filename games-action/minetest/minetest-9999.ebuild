# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils cmake-utils git-2 games

DESCRIPTION="Building single/multiplayer game (engine)"
HOMEPAGE="http://c55.me/minetest/"
SRC_URI=""

EGIT_REPO_URI="git://github.com/celeron55/${PN}.git"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"

KEYWORDS=""
IUSE="+client nls +server"

RDEPEND="app-arch/bzip2
	dev-db/sqlite:3
	dev-lang/lua
	>=dev-libs/jthread-1.2
	media-libs/libpng:0
	media-libs/libvorbis
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXxf86vm
	virtual/jpeg
	virtual/opengl
	nls? ( virtual/libintl )
	"
DEPEND="${RDEPEND}
	>=dev-games/irrlicht-1.7
	nls? ( sys-devel/gettext )
	"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.4_pre20120408-jthread.patch \
		"${FILESDIR}"/minetest-0.4.1_p20120723-lua.patch
	rm -r src/{jthread,lua,sqlite} || die
}

src_configure() {
	local mycmakeargs=(
		-DRUN_IN_PLACE=0
		-DCUSTOM_SHAREDIR="${GAMES_DATADIR}/${PN}"
		-DCUSTOM_BINDIR="${GAMES_BINDIR}"
		$(cmake-utils_use_build client CLIENT)
		$(cmake-utils_use_build server SERVER)
		$(cmake-utils_use_enable nls GETTEXT)
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
