# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games

MY_PN="Unvanquished"

DESCRIPTION="Datafiles and maps for unvanquished"
HOMEPAGE="http://unvanquished.net/"
SRC_URI="mirror://sourceforge/${PN%-data}/${MY_PN}-0.5.0.zip -> ${PN}-0.5.0.zip
	mirror://sourceforge/${PN%-data}/vms-0.5.1.pk3"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}/Unvanquished

src_install() {
	insinto "${GAMES_DATADIR}"/${PN%-data}/main
	doins main/*.pk3
	rm "${D}${GAMES_DATADIR}"/${PN%-data}/main/vms-0.5.0.pk3 || die
	doins "${DISTDIR}"/vms-0.5.1.pk3

	prepgamesdirs
}
