# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils cmake-utils git-2 gnome2-utils vcs-snapshot games

DESCRIPTION="Building single/multiplayer game similar to Minecraft"
HOMEPAGE="http://c55.me/minetest/"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated nls +server"

RDEPEND="dev-db/sqlite:3
	!games-action/minetest_game
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
	)
	nls? ( virtual/libintl )"
# XXX: support shared lib for irrlicht
DEPEND="${RDEPEND}
	>=dev-games/irrlicht-1.7
	nls? ( sys-devel/gettext )"

src_unpack() {
	EGIT_REPO_URI="git://github.com/celeron55/${PN}.git" \
	git-2_src_unpack

	EGIT_REPO_URI="git://github.com/celeron55/minetest_game.git" \
	EGIT_SOURCEDIR="${WORKDIR}/minetest_game" \
	git-2_src_unpack
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

	insinto "${GAMES_DATADIR}"/${PN}/games/${PN}
	doins -r "${WORKDIR}"/minetest_game/mods
	doins "${WORKDIR}"/minetest_game/game.conf

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
