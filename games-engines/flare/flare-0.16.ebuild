# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils cmake-utils versionator games

MY_PV="v$(delete_version_separator 1 $(replace_version_separator 2 '_'))"
MY_P="${PN}_linux_${MY_PV}"

DESCRIPTION="Free/Libre Action Roleplaying Engine"
HOMEPAGE="http://flarerpg.org/"
SRC_URI="mirror://github/clintbellanger/${PN}/${MY_P}.zip
	mirror://github/arx/ArxGentoo/${MY_P}.zip"

# Code is GPL, assets are CC-BY-SA
LICENSE="GPL-3 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl[X,audio,joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${PN}_${MY_PV}

src_prepare() {
	sed \
		-e 's/flare.svg/flare/' \
		-i distribution/flare.desktop.in \
		|| die "fixing desktop file failed!"

	epatch "${FILESDIR}"/${P}-build.patch
}

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
	dodoc README
	prepgamesdirs
}
