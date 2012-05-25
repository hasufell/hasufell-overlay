# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI=2

inherit vcs-snapshot games

DESCRIPTION="Solve routing puzzles in the inner city with Cube Trains"
HOMEPAGE="http://ddr0.github.com/"
SRC_URI="https://github.com/DDR0/Cube_Trains/zipball/${PV} -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/boost-1.35
	media-libs/libsdl[X]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf[X]
	media-libs/glew
	sys-libs/zlib
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_unpack() {
	vcs-snapshot_src_unpack
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
}

src_install() {
	newgamesbin game ${PN}-bin || die
	games_make_wrapper ${PN} ${PN}-bin "${GAMES_DATADIR}/${PN}"

	insinto "${GAMES_DATADIR}"/${PN}
	doins master-config.cfg *.ttf || die

	insinto "${GAMES_DATADIR}"/${PN}/modules/cube_trains
	doins -r modules/cube_trains/* || die "doins failed"

	newicon modules/cube_trains/images/window-icon.png ${PN}.png
	make_desktop_entry ${PN}
	prepgamesdirs
}
