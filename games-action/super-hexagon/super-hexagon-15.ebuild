# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils games

DESCRIPTION="A minimal action game by Terry Cavanagh, with music by Chipzel"
HOMEPAGE="http://www.superhexagon.com/"
SRC_URI="${PN}-linux-${PV}-bin"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs +bundled-glew"
RESTRICT="bindist fetch"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/x86/*
	${MYGAMEDIR#/}/x86_64/*"

DEPEND="app-arch/unzip"
RDEPEND="
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXxf86vm
	!bundled-libs? (
		media-libs/freeglut
		media-libs/libogg
		media-libs/libvorbis
		media-libs/openal
	)
	!bundled-glew? ( ~media-libs/glew-1.6.0 )"

S=${WORKDIR}/data

pkg_pretend() {
	if has splitdebug ${FEATURES}; then
		eerror "FEATURES=splitdebug is broken for this package, disable it locally"
		die "FEATURES=splitdebug is broken for this package, disable it locally"
	fi
}

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
}

src_unpack() {
	# self unpacking zip archive; unzip warns about the exe stuff
	unzip -q "${DISTDIR}"/${A}
	[[ $? -gt 1 ]] && die "unpacking failed"
}

src_prepare() {
	einfo "removing ${ARCH} unrelated files"
	rm -r $(usex amd64 "x86" "x86_64") || die

	if ! use bundled-libs ; then
		einfo "removing bundled-libs..."
		cd $(usex amd64 "x86_64" "x86") || die
		rm libglut.so* libogg.so* libopenal.so* libstdc++.so*\
			libvorbis.so* libvorbisfile.so* \
			$(usex bundled-glew "" "libGLEW.so.1.6") || die
	fi
}

src_install() {
	local myarch=$(usex amd64 "x86_64" "x86")

	insinto "${MYGAMEDIR}"
	doins -r data ${myarch}

	dodoc Linux.README

	newicon SuperHexagon.png ${PN}.png
	make_desktop_entry ${PN}
	games_make_wrapper ${PN} "./${myarch}/superhexagon.${myarch}" "${MYGAMEDIR}" "${MYGAMEDIR}/${myarch}"

	fperms +x "${MYGAMEDIR}/${myarch}/superhexagon.${myarch}"
	prepgamesdirs
}
