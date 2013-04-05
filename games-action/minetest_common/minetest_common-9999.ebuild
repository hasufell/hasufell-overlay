# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-2 games

DESCRIPTION="Minetest Common Mods"
HOMEPAGE="https://github.com/minetest/common"
EGIT_REPO_URI="git://github.com/minetest/common.git"

LICENSE="GPL-2 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="~games-action/minetest-${PV}[-dedicated]"

src_unpack() {
	git-2_src_unpack
}

src_install() {
	insinto "${GAMES_DATADIR}"/minetest/games/common
	doins -r mods

	prepgamesdirs
}
