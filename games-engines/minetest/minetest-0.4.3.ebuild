# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils cmake-utils gnome2-utils git-2 games

DESCRIPTION="Building single/multiplayer engine similar to Minecraft"
HOMEPAGE="http://c55.me/minetest/"
SRC_URI=""

EGIT_REPO_URI="git://github.com/celeron55/${PN}.git"
EGIT_COMMIT="${PV}"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="dedicated nls +server"

RDEPEND="dev-db/sqlite:3
	dev-lang/lua
	>=dev-libs/jthread-1.2
	sys-libs/zlib
	!dedicated? (
		app-arch/bzip2
		media-libs/libogg
		media-libs/libpng:0
		media-libs/libvorbis
		media-libs/openal
		virtual/jpeg
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXxf86vm
	)"
DEPEND="${RDEPEND}
	>=dev-games/irrlicht-1.7
	nls? ( sys-devel/gettext )"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-{jthread,lua}.patch
	rm -r src/{jthread,lua,sqlite} || die
}

src_configure() {
	local mycmakeargs=(
		-DRUN_IN_PLACE=0
		-DCUSTOM_SHAREDIR="${GAMES_DATADIR}/${PN}"
		-DCUSTOM_BINDIR="${GAMES_BINDIR}"
		-DCUSTOM_DOCDIR="/usr/share/doc/${PF}"
		$(usex dedicated "-DBUILD_SERVER=ON -DBUILD_CLIENT=OFF" "$(cmake-utils_use_build server SERVER) -DBUILD_CLIENT=ON")
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

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst

	if !use dedicated ; then
		einfo
		elog "This is just the engine part of minetest. In order to play the full game"
		elog "you need games-action/minetest_game"
		einfo
	fi

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
