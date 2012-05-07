# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils eutils games

MY_PN="Unvanquished"

DESCRIPTION="Daemon engine, a fork of OpenWolf which powers the game Unvanquished"
HOMEPAGE="http://unvanquished.net/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/tarball/v0.3.5
	-> ${P}.tar.gz"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-2.5 CCPL-Attribution-ShareAlike-3.0 as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+cpuinfo +client daemonmap +glsl mumble ncurses mysql openal +server theora +voip vorbis +webp xvid"

RDEPEND="
	dev-libs/nettle[gmp]
	dev-libs/gmp:0
	~games-fps/${PN}-data-${PV}
	media-libs/freetype:2
	media-libs/glew
	media-libs/libogg
	media-libs/libpng:0
	media-libs/libsdl[X,opengl,video]
	net-misc/curl
	sys-libs/glibc
	sys-libs/zlib
	virtual/glu
	virtual/jpeg
	virtual/opengl
	x11-libs/libX11
	mysql? ( virtual/mysql )
	ncurses? ( sys-libs/ncurses )
	openal? ( media-libs/openal )
	voip? ( media-libs/speex )
	vorbis? (
		media-libs/libvorbis
		theora? ( media-libs/libtheora )
		)
	webp? ( media-libs/libwebp )
	xvid? ( media-libs/xvid )
	"
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}-${MY_PN}-9fdb3c0

CMAKE_VERBOSE=1
CMAKE_IN_SOURCE_BUILD=1

src_unpack() {
	unpack ${A}

	cp "${FILESDIR}"/${PN}{,-server}.sh "${T}"/ || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-{cmake,nosuffix}.patch

	# set paths
	sed \
		-e "s#@GAMES_LIBDIR@#$(games_get_libdir)#g" \
		-e "s#@GAMES_BINDIR@#${GAMES_BINDIR}#g" \
		-e "s#@GAMES_STATEDIR@#${GAMES_STATEDIR}#g" \
		-i "${T}"/${PN}{,-server}.sh || die
}

src_configure() {
	# theora requires vorbis
	local mycmakeargs=(
		-DBINDIR="${GAMES_BINDIR}"
		-DLIBDIR="$(games_get_libdir)/${PN}"
		$(cmake-utils_use_build client CLIENT)
		$(cmake-utils_use_build daemonmap DAEMONMAP)
		$(cmake-utils_use_build server SERVER)
		$(cmake-utils_use_use cpuinfo CPUINFIO)
		$(cmake-utils_use_use glsl GLSL_OPTIMIZER)
		$(cmake-utils_use_use mumble MUMBLE)
		$(cmake-utils_use_use mysql MYSQL)
		$(cmake-utils_use_use ncurses CURSES)
		$(cmake-utils_use_use openal OPENAL)
		$(cmake-utils_use_use voip VOIP)
		$(cmake-utils_use_use vorbis CODEC_VORBIS)
		$(usex vorbis "$(cmake-utils_use_use theora CIN_THEORA)" "")
		$(cmake-utils_use_use webp WEBP)
		$(cmake-utils_use_use xvid CIN_XVID)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	# bin
	newgamesbin daemon ${PN}client || die
	if use server ; then
		newgamesbin daemonded ${PN}ded || die
	fi
	if use daemonmap ; then
		newgamesbin daemonmap ${PN}map || die
	fi

	# lib
	exeinto "$(games_get_libdir)"/${PN}
	doexe *.so || die
	exeinto "$(games_get_libdir)"/${PN}/main
	doexe main/*.so || die

	# conf
	insinto "${GAMES_DATADIR}"/${PN}
	doins "${FILESDIR}"/config/{maprotation,server}.cfg.example || die

	# wrappers
	newgamesbin "${T}"/unvanquished.sh ${PN}
	newgamesbin "${T}"/unvanquished-server.sh ${PN}-server

	# other
	doicon debian/${PN}.png
	make_desktop_entry ${PN}

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if use server ; then
		elog
		elog "To configure your dedicated server, you need to copy the files"
		elog "${GAMES_DATADIR}/${PN}/server.cfg.example"
		elog "${GAMES_DATADIR}/${PN}/maprotation.cfg.example"
		elog "into ~/.Unvanquished/main (better create a seperate user)"
		elog
		elog "To run your dedicated server issue:"
		elog "unvanquished-server +set net_ip \$NET_IP +set dedicated 2"
		elog "\$NET_IP can be 'localhost' or the DNS/IP of your internet interface"
		elog "'+set dedicated 2' will advertise your server on the public list"
	fi
}
