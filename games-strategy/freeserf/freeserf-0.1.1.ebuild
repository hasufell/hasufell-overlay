# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils games

DESCRIPTION="Settlers 1 (Serf city) clone"
HOMEPAGE="http://jonls.dk/freeserf/"
SRC_URI="https://github.com/freeserf/freeserf/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +mixer"

RDEPEND="media-libs/libsdl[X,audio,video]
	mixer? ( media-libs/sdl-mixer[timidity] )"
DEPEND="${RDEPEND}
	mixer? ( virtual/pkgconfig )"

DOCS=( README.md )

src_prepare() {
	epatch "${FILESDIR}"/${P}-cflags.patch

	# needs .git folder
	cat <<-EOF > src/version_vcs.h || die
	#ifndef VERSION_VCS_H
	#define VERSION_VCS_H
	#define VERSION_VCS "v0.1.1-84-gdd75627"
	#endif /* VERSION_VCS_H */
	EOF

	eautoreconf
}

src_configure() {
	egamesconf \
		$(use_enable debug) \
		$(use_enable mixer sdl-mixer)
}

src_install() {
	default
	prepgamesdirs
}

pkg_postinst() {
	elog "Instructions on how to install the data files can be found at"
	elog "/usr/share/doc/${PF}/README.md"
}
