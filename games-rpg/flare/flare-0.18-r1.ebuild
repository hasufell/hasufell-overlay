# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils games

DESCRIPTION="Free/Libre Action Roleplaying game"
HOMEPAGE="https://github.com/clintbellanger/flare-game"
SRC_URI="mirror://sourceforge/flare-game/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	!games-engines/flare
	media-libs/libsdl[X,audio,joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBINDIR="${GAMES_BINDIR}"
		-DDATADIR="${GAMES_DATADIR}/${PN}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc README.engine
	prepgamesdirs
}
