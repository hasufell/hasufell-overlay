# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

MY_PN="Unvanquished"

DESCRIPTION="Datafiles and maps for unvanquished"
HOMEPAGE="http://unvanquished.net/"
SRC_URI="mirror://sourceforge/${PN%-data}/${MY_PN}_0.5.1.zip -> ${PN}-0.5.1.zip
	mirror://sourceforge/${PN%-data}/vms-0.12.0.pk3
	mirror://sourceforge/${PN%-data}/map-plat23-b6.pk3
	mirror://sourceforge/${PN%-data}/map-parpax-b03.pk3
	mirror://sourceforge/${PN%-data}/map-parpax-b03h.pk3
	mirror://sourceforge/${PN%-data}/map-thunder-b1.pk3
	mirror://sourceforge/${PN%-data}/map-plat23-b7.pk3
	mirror://sourceforge/${PN%-data}/map-parpax-b04.pk3
	mirror://sourceforge/${PN%-data}/map-yocto-a916.pk3
	mirror://sourceforge/${PN%-data}/map-parpax-b04a.pk3
	mirror://sourceforge/${PN%-data}/map-plat23-b8.pk3
	mirror://sourceforge/${PN%-data}/map-yocto-b1.pk3
	mirror://sourceforge/${PN%-data}/pak5.pk3 -> unv-pak5.pk3
	mirror://sourceforge/${PN%-data}/pak6.pk3 -> unv-pak6.pk3
	mirror://sourceforge/${PN%-data}/pak7.pk3 -> unv-pak7.pk3
	mirror://sourceforge/${PN%-data}/pak8.pk3 -> unv-pak8.pk3
	mirror://sourceforge/${PN%-data}/pak9.pk3 -> unv-pak9.pk3
	mirror://sourceforge/${PN%-data}/pakA.pk3 -> unv-pakA.pk3
	mirror://sourceforge/${PN%-data}/pakB.pk3 -> unv-pakB.pk3"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks"

DEPEND="app-arch/unzip"

S=${WORKDIR}/Unvanquished

src_unpack() {
	unpack ${PN}-0.5.1.zip
}

src_install() {
	local f

	insinto "${GAMES_DATADIR}"/${PN%-data}/main
	doins main/*.pk3 "${DISTDIR}"/*.pk3
	rm "${D}${GAMES_DATADIR}"/${PN%-data}/main/vms-0.5.1.pk3 || die

	cd "${D}${GAMES_DATADIR}/${PN%-data}/main" || die
	for f in $(find . -type f -name "unv-pak*.pk3") ; do
		mv ${f} ${f/unv-/} || die
	done

	prepgamesdirs
}
