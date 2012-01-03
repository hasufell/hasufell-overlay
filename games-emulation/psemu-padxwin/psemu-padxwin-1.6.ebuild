# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games

DESCRIPTION="PSEmu plugin to use the keyboard as a gamepad"
HOMEPAGE="http://www.pcsx.net/"
SRC_URI="http://linuzappz.pcsx.net/downloads/padXwin-${PV}.tgz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND="x86? ( x11-libs/gtk+:1 )
	amd64? ( app-emulation/emul-linux-x86-gtklibs )"

S="${WORKDIR}"

src_install() {
	dodoc ReadMe.txt
	cd bin
	exeinto "$(games_get_libdir)"/psemu/plugins
	doexe libpadXwin-* || die "doexe failed"
	exeinto "$(games_get_libdir)"/psemu/cfg
	doexe cfgPadXwin || die "doexe failed"
	prepgamesdirs
}
