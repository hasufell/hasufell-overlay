# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

MY_PN="Unvanquished"
MY_P=${PN%-data}_${PV}

DESCRIPTION="Datafiles and maps for unvanquished"
HOMEPAGE="http://unvanquished.net/"
SRC_URI="mirror://sourceforge/${PN%-data}/${MY_P}.zip"

LICENSE="CC-BY-SA-2.5 CC-BY-SA-3.0 CC-BY-NC-SA-3.0 CC-BY-NC-3.0 shaderlab"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks"

DEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN%-data}/pkg
	doins -r pkg/*
	prepgamesdirs
}
