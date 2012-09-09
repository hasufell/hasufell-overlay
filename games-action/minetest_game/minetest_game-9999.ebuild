# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit git-2 games

DESCRIPTION="Building single/multiplayer game similar to Minecraft"
HOMEPAGE="http://c55.me/minetest/"
EGIT_REPO_URI="git://github.com/celeron55/${PN}.git"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="~games-action/minetest-${PV}[-dedicated]"

src_unpack() {
	git-2_src_unpack
}

src_install() {
	insinto "${GAMES_DATADIR}"/minetest/games/${PN}
	doins -r mods
	doins game.conf

	prepgamesdirs
}
