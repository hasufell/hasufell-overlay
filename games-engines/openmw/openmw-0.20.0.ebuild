# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils cmake-utils games

DESCRIPTION="An open source reimplementation of TES III: Morrowind"
HOMEPAGE="http://openmw.org/"
SRC_URI="http://launchpad.net/~${PN}/+archive/${PN}/+files/${PN}_${PV}.orig.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdinstall ffmpeg +mpg123 test"

# XXX static build
RDEPEND=">=dev-games/mygui-3.2.0
	>=dev-games/ogre-1.8.0[cg,freeimage,ois,opengl,zip]
	dev-games/ois
	>=dev-libs/boost-1.46.0
	media-libs/freetype:2
	media-libs/openal
	>=sci-physics/bullet-2.80
	>=dev-qt/qtcore-4.7.0:4
	>=dev-qt/qtgui-4.7.0:4
	ffmpeg? ( media-video/ffmpeg )
	mpg123? ( media-libs/libsndfile
		media-sound/mpg123 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-cpp/gmock
		dev-cpp/gtest )"
PDEPEND="cdinstall? ( games-rpg/morrowind-data )"

REQUIRED_USE="^^ ( mpg123 ffmpeg )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.15.0-cfg.patch

	sed \
		-e "s#globalPath(\"/etc/\")#globalPath(\"${GAMES_SYSCONFDIR}\")#" \
		-i components/files/linuxpath.cpp || die "fixing global confdir failed!"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build test UNITTESTS)
		$(cmake-utils_use_use ffmpeg FFMPEG)
		$(cmake-utils_use_use mpg123 MPG123)
		-DBINDIR="${GAMES_BINDIR}"
		-DDATADIR="${GAMES_DATADIR}"/${PN}
		-DSYSCONFDIR="${GAMES_SYSCONFDIR}"/${PN}
		-DICONDIR=/usr/share/icons/hicolor/256x256/apps
		-DMORROWIND_DATA_FILES="${GAMES_DATADIR}"/morrowind-data
		-DMORROWIND_RESOURCE_FILES="${GAMES_DATADIR}"/${PN}/resources
		-DUSE_AUDIERE=OFF
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc readme.txt
	prepgamesdirs
}

src_test() {
	"${CMAKE_BUILD_DIR}"/${PN}_test_suite || die
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update

	ewarn
	ewarn "If you have your data files on an NTFS partition"
	ewarn "openmw might be very slow or even unable to load the data!"
	ewarn
}

pkg_postrm() {
	gnome2_icon_cache_update
}
