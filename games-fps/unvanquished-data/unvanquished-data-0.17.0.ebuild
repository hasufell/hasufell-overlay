# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

MY_PN="Unvanquished"

DESCRIPTION="Datafiles and maps for unvanquished"
HOMEPAGE="http://unvanquished.net/"
SRC_URI="
	mirror://sourceforge/${PN%-data}/${PN%-data}-${PV:0:4}-universal.zip
"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks"

DEPEND="app-arch/unzip"

S=${WORKDIR}/unvanquished

src_install() {
	insinto "${GAMES_DATADIR}"/${PN%-data}
	doins -r main

	prepgamesdirs
}
