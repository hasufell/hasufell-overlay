# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

DESCRIPTION="ePSXe PlayStation Emulator"
HOMEPAGE="http://www.epsxe.com/"
SRC_URI="http://www.epsxe.com/files/epsxe${PV//.}lin.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"
RESTRICT="strip"

DEPEND="app-arch/unzip"
RDEPEND="games-emulation/psemu-peopsspu
	opengl? ( games-emulation/psemu-gpupetemesagl )
	!opengl? ( games-emulation/psemu-peopssoftgpu )
	amd64? ( app-emulation/emul-linux-x86-gtklibs )
	x86? ( x11-libs/gtk+:1 )"

# plugins optional

S="${WORKDIR}"

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	dogamesbin "${FILESDIR}"/epsxe
	sed -i \
		-e "s:GAMES_PREFIX_OPT:${GAMES_PREFIX_OPT}:" \
		-e "s:GAMES_LIBDIR:$(games_get_libdir):" \
		"${D}${GAMES_BINDIR}"/epsxe \
		|| die
	exeinto "${dir}"
	doexe epsxe || die
	insinto "${dir}"
	doins keycodes.lst || die
	insinto "$(games_get_libdir)"/psemu/cheats
	doins cheats/* || die
	dodoc docs/* || die
	prepgamesdirs
}
