# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cdrom check-reqs games

DESCRIPTION="The Elder Scrolls III: Morrowind - data extractor"
HOMEPAGE="http://www.elderscrolls.com/"
SRC_URI=""

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks"

RDEPEND="games-engines/openmw"
DEPEND="app-arch/unshield"

S=${WORKDIR}

CHECKREQS_DISK_BUILD="622M"
CHECKREQS_DISK_USR="741M"

src_unpack() {
	cdrom_get_cds data1.cab

	unshield x "${CDROM_ROOT}"/data1.cab || die "unpacking data1.cab failed!"
	unshield x "${CDROM_ROOT}"/data2.cab || die "unpacking data2.cab failed!"
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r "${CDROM_ROOT}"/Video
	doins App_Executables/Morrowind.ini Data_Files/*
	doins -r Music Sound Splash Fonts

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "This is just the data portion of the game. You will need to install"
	elog "games-engines/openmw to play the game."
}
