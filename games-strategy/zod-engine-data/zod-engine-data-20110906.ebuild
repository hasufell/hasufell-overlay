# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit games

MY_P=zod_linux-${PV:0:4}-${PV:4:2}-${PV:6:2}
DESCRIPTION="Zod engine data files"
HOMEPAGE=""
SRC_URI="${MY_P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="fetch bindist"

RDEPEND="~games-strategy/zod-engine-${PV}"

S=${WORKDIR}/zod_engine

pkg_nofetch() {
	einfo "Please download the latest linux tarball from"
	einfo "the homepage and move it to ${DISTDIR}"
	echo
}

src_prepare() {
	# remove unused files
	find "${S}" -type f \( -name Thumbs.db -o -name "*.xcf" -o -name "*.ico" \) -delete || die
	rm assets/{splash.png,WebCamScene.icescene} || die
}

src_compile() {
	:
}

src_install() {
	insinto "${GAMES_DATADIR}/zod-engine"
	doins -r assets blank_maps *.map default_settings.txt *map_list.txt
	prepgamesdirs
}
