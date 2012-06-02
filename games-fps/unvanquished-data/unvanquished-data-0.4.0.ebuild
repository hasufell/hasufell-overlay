# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

MY_PN="Unvanquished"

DESCRIPTION="Datafiles and maps for unvanquished"
HOMEPAGE="http://unvanquished.net/"
SRC_URI="mirror://sourceforge/${PN%-data}/${MY_PN}-${PV}.zip"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_PN}

src_install() {
	keepdir "${GAMES_DATADIR}"/${PN%-data}/main
	insinto "${GAMES_DATADIR}"/${PN%-data}/main
	doins main/*.pk3 || die

	prepgamesdirs
}
