# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/wargus/wargus-2.2.5.5.ebuild,v 1.7 2012/05/17 18:06:23 mr_bones_ Exp $

EAPI=2
inherit bzr cdrom cmake-utils gnome2-utils games

DESCRIPTION="Warcraft II for the Stratagus game engine (Needs WC2 DOS CD)"
HOMEPAGE="http://wargus.sourceforge.net/"
SRC_URI=""
EBZR_REPO_URI="lp:wargus"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="=games-engines/stratagus-${PV}*[theora]
	media-libs/freetype
	media-libs/libpng:0
	sys-libs/zlib
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
PDEPEND="games-strategy/wargus-data"

src_unpack() {
	bzr_src_unpack
}

src_prepare() {
	sed \
		-e "/^Exec/s#/usr/games/wargus#${GAMES_BINDIR}/wargus#" \
		-i wargus.desktop
}

src_configure() {
	local mycmakeargs=(
		-DBINDIR="${GAMES_BINDIR}"
		-DGAMEDIR="${GAMES_BINDIR}"
		-DSTRATAGUS="${GAMES_BINDIR}"/stratagus
		-DICONDIR=/usr/share/icons/hicolor/64x64/apps
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
	elog "Enabling OpenGL ingame seems to cause segfaults/crashes."
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
