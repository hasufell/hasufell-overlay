# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils toolchain-funcs games vcs-snapshot

DESCRIPTION="Open Source Commander Keen clone"
HOMEPAGE="http://clonekeenplus.sourceforge.ne"
SRC_URI="https://github.com/gerstrong/Commander-Genius/tarball/version${PV/_beta/beta} -> ${P}.tar.gz"

LICENSE="|| ( GPL-1 GPL-2 GPL-3 ) LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tremor"

RDEPEND="media-libs/libogg
	media-libs/libsdl[X,audio,opengl,video]
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libxcb
	!tremor? ( media-libs/libvorbis )
	tremor? ( media-libs/tremor )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CMAKE_IN_SOURCE_BUILD=1

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 7 || $(gcc-major-version) -lt 4 ]] ; then
			eerror "You need at least sys-devel/gcc-4.7.0"
			die "You need at least sys-devel/gcc-4.7.0"
		fi
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-{cmake,findfile}.patch

	sed \
		-e "/SYSTEM_DATA_DIR/s#/usr/share#${GAMES_DATADIR}#" \
		-i src/FindFile.h || die
}

src_configure() {
	local mycmakeargs arch
	arch=$(tc-arch)

	case $arch in
		amd64)
			mycmakeargs=(
				-DBUILD_TYPE=LINUX64
				-DHAVE_64_BIT=1
				)
			;;
		x86)
			mycmakeargs=(
				-DBUILD_TYPE=LINUX32
				-DHAVE_64_BIT=0
				)
			;;
		*)
			die "unsopported architecture"
			;;
	esac

	mycmakeargs+=(
		-DAPPDIR="${GAMES_BINDIR}"
		-DSHAREDIR="${GAMES_DATADIR}"/CommanderGenius
		-DDOCDIR="/usr/share/${PF}/doc"
		$(cmake-utils_use !tremor OGG)
		$(cmake-utils_use tremor TREMOR)
		)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	newicon CGLogo.png ${PN}.png
	make_desktop_entry CommanderGenius
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "Check your settings in ~/.CommanderGenius/cgenius.cfg"
	elog "after you have first started the game. You may need to"
	elog "set \"OpenGL = true\" and adjust other settings."
}
