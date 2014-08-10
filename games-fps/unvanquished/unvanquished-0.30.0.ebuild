# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils eutils flag-o-matic user gnome2-utils python-any-r1 games

MY_PN="Unvanquished"

DESCRIPTION="Daemon engine, a fork of OpenWolf which powers the game Unvanquished"
HOMEPAGE="http://unvanquished.net/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/tarball/v${PV}
	-> ${P}.tar.gz
	x86? ( http://vanquished.zapto.org/~amanieu/unvanquished_deps/linux32-2.tar.bz2 -> unvanquished-${PV}-external-x86-2.tar.bz2 )
	amd64? ( http://vanquished.zapto.org/~amanieu/unvanquished_deps/linux64-2.tar.bz2 -> unvanquished-${PV}-external-amd64-2.tar.bz2 )"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-2.5 CCPL-Attribution-ShareAlike-3.0 as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated geoip +optimization sdl2 +server +smp +voip"

RDEPEND="
	dev-libs/nettle[gmp]
	dev-libs/gmp:0
	~games-fps/${PN}-data-${PV}
	net-misc/curl
	sys-libs/zlib
	!dedicated? (
		media-libs/freetype:2
		media-libs/glew
		media-libs/libogg
		media-libs/libpng:0
		media-libs/libtheora
		media-libs/libvorbis
		media-libs/libwebp
		media-libs/openal
		media-libs/opusfile
		sys-libs/ncurses
		virtual/glu
		virtual/jpeg
		virtual/opengl
		x11-libs/libX11
		sdl2? ( media-libs/libsdl2[X,opengl,video] )
		!sdl2? ( media-libs/libsdl[X,opengl,video] )
		server? ( app-misc/screen )
		voip? ( media-libs/speex )
	)
	dedicated? (
		app-misc/screen
		sys-libs/ncurses
		voip? ( media-libs/speex )
	)
	geoip? ( dev-libs/geoip )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

CMAKE_IN_SOURCE_BUILD=1

UNV_SERVER_HOME=${GAMES_STATEDIR}/${PN}-server
UNV_SERVER_DATA=${UNV_SERVER_HOME}/.Unvanquished/main

pkg_setup() {
	games_pkg_setup

	if use server || use dedicated ; then
		enewuser \
			"${PN}-server" \
			"-1" \
			"/bin/sh" \
			"${UNV_SERVER_HOME}" \
			"games"
	fi

	python-any-r1_pkg_setup
}

src_unpack() {
	default
	mv Unvanquished-Unvanquished-* "${S}" || die
	mv "linux$(usex amd64 "64" "32")-2" "${S}"/external_deps/ || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch

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
	if use optimization ; then
		append-cflags -ffast-math -fno-strict-aliasing
		append-cxxflags -ffast-math -fno-strict-aliasing -fvisibility=hidden
	fi
	append-cxxflags -std=gnu++11

	# theora requires vorbis
	local mycmakeargs=(
		-DUSE_LTO=0
		-DUSE_HARDENING=0
		-DUSE_PRECOMPILED_HEADER=0
		$(usex dedicated "-DBUILD_CLIENT=OFF" "-DBUILD_CLIENT=ON")
		-DBUILD_TTY_CLIENT=ON
		$(usex dedicated "-DBUILD_SERVER=ON" "$(cmake-utils_use_build server SERVER)")
		$(cmake-utils_use_use voip VOIP)
		$(cmake-utils_use_use sdl2 SDL2)
		$(cmake-utils_use_use smp SMP)
		$(cmake-utils_use_use geoip GEOIP)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	if use server || use dedicated ; then
		insinto "${GAMES_SYSCONFDIR}"/${PN}
		doins "${FILESDIR}"/config/{maprotation,server}.cfg

		newinitd "${T}"/${PN}-server.initd ${PN}-server
		newconfd "${T}"/${PN}-server.confd ${PN}-server

		newgamesbin daemonded ${PN}ded
		newgamesbin "${T}"/${PN}-server.sh ${PN}-server
	fi

	if ! use dedicated ; then
		newgamesbin daemon ${PN}client
		newgamesbin "${T}"/${PN}.sh ${PN}

		exeinto "$(games_get_libdir)"/${PN}
		doexe *.so

		doicon -s 128 debian/${PN}.png
		make_desktop_entry ${PN}
		newgamesbin daemon-tty ${PN}-tty
	fi

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	games_pkg_postinst

	if use server || use dedicated ; then
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

pkg_postrm() {
	gnome2_icon_cache_update
}
