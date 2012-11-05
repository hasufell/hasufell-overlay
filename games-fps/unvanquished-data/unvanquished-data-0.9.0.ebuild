# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games

MY_PN="Unvanquished"

DESCRIPTION="Datafiles and maps for unvanquished"
HOMEPAGE="http://unvanquished.net/"
SRC_URI="mirror://sourceforge/${PN%-data}/${MY_PN}_0.5.1.zip -> ${PN}-0.5.1.zip
	mirror://sourceforge/${PN%-data}/vms-0.9.0.pk3
	mirror://sourceforge/${PN%-data}/map-plat23-b6.pk3
	mirror://sourceforge/${PN%-data}/map-parpax-b03.pk3
	mirror://sourceforge/${PN%-data}/map-parpax-b03h.pk3
	mirror://sourceforge/${PN%-data}/map-thunder-b1.pk3
	mirror://sourceforge/${PN%-data}/map-plat23-b7.pk3
	mirror://sourceforge/${PN%-data}/pak5.pk3 -> unv-pak5.pk3
	mirror://sourceforge/${PN%-data}/pak6.pk3 -> unv-pak6.pk3
	mirror://sourceforge/${PN%-data}/pak7.pk3 -> unv-pak7.pk3
	mirror://sourceforge/${PN%-data}/pak8.pk3 -> unv-pak8.pk3"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}/Unvanquished

src_install() {
	insinto "${GAMES_DATADIR}"/${PN%-data}/main
	doins main/*.pk3
	rm "${D}${GAMES_DATADIR}"/${PN%-data}/main/vms-0.5.1.pk3 || die
	doins "${DISTDIR}"/{vms-0.9.0,map-plat23-b6,map-parpax-b03,map-parpax-b03h,map-thunder-b1,map-plat23-b7}.pk3

	for i in 5 6 7 8 ; do
		newins "${DISTDIR}"/unv-pak${i}.pk3 pak${i}.pk3
	done

	prepgamesdirs
}
