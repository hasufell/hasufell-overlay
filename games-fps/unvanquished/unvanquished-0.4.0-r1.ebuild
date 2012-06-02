# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils eutils user games vcs-snapshot

MY_PN="Unvanquished"

DESCRIPTION="Daemon engine, a fork of OpenWolf which powers the game Unvanquished"
HOMEPAGE="http://unvanquished.net/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/tarball/v${PV}
	-> ${P}.tar.gz"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-2.5 CCPL-Attribution-ShareAlike-3.0 as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cpuinfo +client daemonmap debug +glsl mumble ncurses mysql openal +server theora +voip vorbis +webp xvid"

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
	server? ( app-misc/screen )
	voip? ( media-libs/speex )
	vorbis? (
		media-libs/libvorbis
		theora? ( media-libs/libtheora )
		)
	webp? ( media-libs/libwebp )
	xvid? ( media-libs/xvid )
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="theora? ( vorbis )"

CMAKE_IN_SOURCE_BUILD=1

UNV_SERVER_HOME=${GAMES_STATEDIR}/${PN}-server
UNV_SERVER_DATA=${UNV_SERVER_HOME}/.Unvanquished/main

pkg_setup() {
	games_pkg_setup

	if use server ; then
		enewuser \
			"${PN}-server" \
			"-1" \
			"/bin/sh" \
			"${UNV_SERVER_HOME}" \
			"games"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-cmake.patch

	# set paths
	for i in ${PN}-server.{confd,initd,sh} ${PN}.sh ; do
		sed \
			-e "s#@GAMES_LIBDIR@#$(games_get_libdir)#g" \
			-e "s#@GAMES_BINDIR@#${GAMES_BINDIR}#g" \
			-e "s#@GAMES_DATADIR@#${GAMES_DATADIR}#g" \
			-e "s#@GAMES_STATEDIR@#${GAMES_STATEDIR}#g" \
			-e "s#@GAMES_SYSCONFDIR@#${GAMES_SYSCONFDIR}#g" \
			-e "s#@UNV_SERVER_DATA@#${UNV_SERVER_DATA}#g" \
			"${FILESDIR}"/${i} > "${T}"/${i} || die
	done
}

src_configure() {
	# theora requires vorbis
	local mycmakeargs=(
		-DCMAKE_INSTALL_BINDIR="${GAMES_BINDIR}"
		-DCMAKE_INSTALL_LIBDIR="$(games_get_libdir)/${PN}"
		$(cmake-utils_use debug QVM_DEBUG)
		$(usex dedicated "-DBUILD_CLIENT=ON" "$(cmake-utils_use_build client CLIENT)")
		$(cmake-utils_use_build daemonmap DAEMONMAP)
		$(usex dedicated "-DBUILD_SERVER=ON" "$(cmake-utils_use_build server SERVER)")
		$(cmake-utils_use_use cpuinfo CPUINFIO)
		$(cmake-utils_use_use glsl GLSL_OPTIMIZER)
		$(cmake-utils_use_use mumble MUMBLE)
		$(cmake-utils_use_use mysql MYSQL)
		$(cmake-utils_use_use ncurses CURSES)
		$(cmake-utils_use_use openal OPENAL)
		$(cmake-utils_use_use voip VOIP)
		$(cmake-utils_use_use vorbis CODEC_VORBIS)
		$(cmake-utils_use_use theora CIN_THEORA)
		$(cmake-utils_use_use webp WEBP)
		$(cmake-utils_use_use xvid CIN_XVID)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	if use server ; then
		insinto "${GAMES_SYSCONFDIR}"/${PN}
		doins "${FILESDIR}"/config/{maprotation,server}.cfg

		newinitd "${T}"/${PN}-server.initd ${PN}-server
		newconfd "${T}"/${PN}-server.confd ${PN}-server

		newgamesbin daemonded ${PN}ded
		newgamesbin "${T}"/${PN}-server.sh ${PN}-server
	fi

	newgamesbin daemon ${PN}client
	newgamesbin "${T}"/${PN}.sh ${PN}

	if use daemonmap ; then
		newgamesbin daemonmap ${PN}map
	fi

	exeinto "$(games_get_libdir)"/${PN}
	doexe *.so
	exeinto "$(games_get_libdir)"/${PN}/main
	doexe main/*.so

	# other
	doicon debian/${PN}.png
	make_desktop_entry ${PN}

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if use server ; then
		elog "To configure your dedicated server, edit the files:"
		elog "${GAMES_SYSCONFDIR}/${PN}/server.cfg"
		elog "${GAMES_SYSCONFDIR}/${PN}/maprotation.cfg"
		elog "/etc/conf.d/${PN}-server"
		elog ""
		elog "To run your dedicated server use the initscript"
		elog "/etc/init.d/${PN}-server which is run"
		elog "as user '${PN}-server' in a screen session."
		elog "The homedir is '${UNV_SERVER_HOME}'."
	fi
}
