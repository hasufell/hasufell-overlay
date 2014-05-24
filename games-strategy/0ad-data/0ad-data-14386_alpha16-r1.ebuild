# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

MY_P=0ad-0.0.16-alpha
DESCRIPTION="Data files for 0ad"
HOMEPAGE="http://wildfiregames.com/0ad/"
SRC_URI="http://releases.wildfiregames.com/${MY_P}-unix-data.tar.xz"

LICENSE="GPL-2 CC-BY-SA-3.0 LPPL-1.3c BitstreamVera"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	die "
0ad has been imported into the main tree with a different
versioning scheme. Please remove this version and run:
    emerge -av games-strategy/0ad::gentoo"
}

src_prepare() {
	rm binaries/data/tools/fontbuilder/fonts/*.txt
}

src_install() {
	insinto "${GAMES_DATADIR}"/0ad
	doins -r binaries/data/*
	prepgamesdirs
}