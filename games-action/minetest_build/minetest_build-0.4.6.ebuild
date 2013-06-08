# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit games vcs-snapshot

DESCRIPTION="Build/Minetest"
HOMEPAGE="https://github.com/minetest/build"
SRC_URI="https://github.com/minetest/build/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=games-action/minetest-${PV}[-dedicated]"

src_install() {
	insinto "${GAMES_DATADIR}"/minetest/games/build
	doins -r mods
	doins game.conf

	prepgamesdirs
}
