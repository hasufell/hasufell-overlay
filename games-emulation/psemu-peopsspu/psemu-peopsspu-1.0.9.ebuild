# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools eutils games

DESCRIPTION="P.E.Op.S Sound Emulation (SPU) PSEmu Plugin"
HOMEPAGE="http://sourceforge.net/projects/peops/"
SRC_URI="mirror://sourceforge/peops/PeopsSpu${PV//./}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa oss"

DEPEND="alsa? ( media-libs/alsa-lib )
	x86? ( x11-libs/gtk+:1 )
	amd64? ( app-emulation/emul-linux-x86-soundlibs )"
RDEPEND="${DEPEND}
	amd64? ( app-emulation/emul-linux-x86-gtklibs )"

S="${WORKDIR}"/src

pkg_setup() {
	if use !alsa && use !oss ; then
		die "must select oss or alsa"
	fi
}

src_unpack() {
	default
	cd src
	epatch "${FILESDIR}"/makefile.patch

	if use amd64 ; then
		sed -i -e "s:-L/usr/lib:-L/usr/lib32:" Makefile
	fi
}

src_compile() {
	if use oss ; then
		emake USEALSA=FALSE || die "oss build failed"
	fi
	if use alsa ; then
		# clean doesn't remove oss-build
		emake clean || die
		emake USEALSA=TRUE || die "alsa build failed"
	fi
}

src_install() {
	# install plugins
	exeinto "$(games_get_libdir)"/psemu/plugins
	if use alsa ; then
		doexe libspuPeopsALSA* || die
	fi
	if use oss ; then
		doexe libspuPeopsOSS* || die
	fi

	# install precompiled gui config-utility
	# due to problematic build system
	exeinto "$(games_get_libdir)"/psemu/cfg
	doexe "${WORKDIR}"/cfgPeopsOSS

	# install cfg
	insinto "$(games_get_libdir)"/psemu/cfg
	doins "${WORKDIR}"/spuPeopsOSS.cfg || die

	dodoc "${WORKDIR}"/*.txt || die
	prepgamesdirs
}
