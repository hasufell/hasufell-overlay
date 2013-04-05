# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-2 games

DESCRIPTION="Build/Minetest"
HOMEPAGE="https://github.com/minetest/build"
EGIT_REPO_URI="git://github.com/minetest/build.git"

LICENSE="GPL-2 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="~games-action/minetest-${PV}[-dedicated]"

src_unpack() {
	git-2_src_unpack
}

src_install() {
	insinto "${GAMES_DATADIR}"/minetest/games/build
	doins -r mods
	doins game.conf

	prepgamesdirs
}
