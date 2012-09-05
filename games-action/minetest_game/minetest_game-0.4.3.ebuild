# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit git-2 games

DESCRIPTION="Building single/multiplayer game similar to Minecraft"
HOMEPAGE="http://c55.me/minetest/"
SRC_URI=""

EGIT_REPO_URI="git://github.com/celeron55/${PN}.git"
EGIT_COMMIT="${PV}"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="~games-engines/minetest-${PV}[-dedicated]"

src_unpack() {
	git-2_src_unpack
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN%_game}/games/${PN}
	doins -r mods
	doins game.conf

	prepgamesdirs
}
