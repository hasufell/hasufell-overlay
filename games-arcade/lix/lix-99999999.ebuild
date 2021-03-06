# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils games git-2

DESCRIPTION="Action-puzzle game, single- and networked multiplayer, inspired by Lemmings"
HOMEPAGE="http://asdfasdf.ethz.ch/~simon/index.php"
EGIT_REPO_URI="https://github.com/SimonN/Lix.git"
SRC_URI="http://dev.gentoo.org/~hasufell/distfiles/${PN}.png"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="media-libs/allegro:0
	media-libs/libpng:0
	net-libs/enet:1.3
	sys-libs/zlib"
DEPEND="virtual/pkgconfig"

src_compile() {
	emake \
		STRIP=touch \
		V=1
}

src_install() {
	local f

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r images/ data/ doc/ levels/

	insinto "${GAMES_STATEDIR}"/${PN}/replays
	doins -r replays/*
	dosym "${GAMES_STATEDIR}"/${PN}/replays "${GAMES_DATADIR}"/${PN}/replays

	for f in ${PN} ${PN}d ; do
		newgamesbin bin/${f} ${f}-bin
		games_make_wrapper ${f} ${f}-bin "${GAMES_DATADIR}/${PN}"
	done
	make_desktop_entry ${PN}

	doicon "${DISTDIR}"/${PN}.png

	prepgamesdirs
}
