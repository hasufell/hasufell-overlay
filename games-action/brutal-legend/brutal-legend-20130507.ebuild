# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# TODO: unbundle libsdl-2 when it hit sthe tree

EAPI=5

inherit eutils unpacker gnome2-utils games

TIMESTAMP=${PV:0:4}-${PV:4:2}-${PV:6:2}
DESCRIPTION="This is totally brutal"
HOMEPAGE="https://www.ea.com/de/brutal-legend"
SRC_URI="BrutalLegend-Linux-${TIMESTAMP}-setup.bin"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/lib/*
	${MYGAMEDIR#/}/Buddha.bin.x86"

RDEPEND="
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-xlibs
	)
	x86? (
		sys-libs/zlib
		virtual/glu
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libxcb

	)"
DEPEND="app-arch/unzip"

S=${WORKDIR}/data

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	newicon -s 256 Buddha.png ${PN}.png
	games_make_wrapper ${PN} "./Buddha.bin.x86" "${MYGAMEDIR}" "${MYGAMEDIR}/lib"
	make_desktop_entry ${PN}

	dodir "${MYGAMEDIR}"
	# this is over 9000!!!! ...eh, 8GB data
	mv * "${D}${MYGAMEDIR}" || die

	fperms +x "${MYGAMEDIR}/Buddha.bin.x86"
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
