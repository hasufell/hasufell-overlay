# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

MY_PN="Unvanquished"

DESCRIPTION="Datafiles and maps for unvanquished"
HOMEPAGE="http://unvanquished.net/"
SRC_URI="mirror://sourceforge/${PN%-data}/${PN%-data}-0.18-universal.zip
	mirror://sourceforge/${PN%-data}/pakI.pk3
	mirror://sourceforge/${PN%-data}/pakJ.pk3
	mirror://sourceforge/${PN%-data}/pakK.pk3
	mirror://sourceforge/${PN%-data}/navmesh-${PV}.pk3
	mirror://sourceforge/${PN%-data}/vms-${PV}.pk3"

LICENSE="CC-BY-SA-2.5 CC-BY-SA-3.0 CC-BY-NC-SA-3.0 CC-BY-NC-3.0 shaderlab"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks"

DEPEND="app-arch/unzip"

S=${WORKDIR}/unvanquished

src_prepare() {
	rm main/vms-0.18.0.pk3 || die
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN%-data}
	doins -r main

	insinto "${GAMES_DATADIR}"/${PN%-data}/main
	doins "${DISTDIR}"/{vms-${PV},navmesh-${PV},pakI,pakJ,pakK}.pk3

	prepgamesdirs
}
