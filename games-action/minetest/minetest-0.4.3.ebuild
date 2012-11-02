# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils cmake-utils gnome2-utils vcs-snapshot games

DESCRIPTION="An InfiniMiner/Minecraft inspired game."
HOMEPAGE="http://c55.me/minetest/"
SRC_URI="http://github.com/celeron55/minetest/tarball/${PV} -> ${P}.tar.gz"

LICENSE="LGPL-2.1+ CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated nls +server"

RDEPEND="dev-db/sqlite:3
	dev-lang/lua
	>=dev-libs/jthread-1.2
	sys-libs/zlib
	!dedicated? (
		app-arch/bzip2
		media-libs/libogg
		media-libs/libpng:0
		media-libs/libvorbis
		media-libs/openal
		virtual/glu
		virtual/jpeg
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXxf86vm
	)
	nls? ( virtual/libintl )"
# XXX: support shared lib for irrlicht
DEPEND="${RDEPEND}
	>=dev-games/irrlicht-1.7
	nls? ( sys-devel/gettext )"

src_unpack() {
	vcs-snapshot_src_unpack
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-jthread.patch \
		"${FILESDIR}"/${P}-lua.patch

	rm -r src/{jthread,lua,sqlite} || die
}

src_configure() {
	local mycmakeargs=(
		-DRUN_IN_PLACE=0
		-DCUSTOM_SHAREDIR="${GAMES_DATADIR}/${PN}"
		-DCUSTOM_BINDIR="${GAMES_BINDIR}"
		-DCUSTOM_DOCDIR="/usr/share/doc/${PF}"
		$(usex dedicated "-DBUILD_SERVER=ON -DBUILD_CLIENT=OFF" "$(cmake-utils_use_build server SERVER) -DBUILD_CLIENT=ON")
		$(cmake-utils_use_enable nls GETTEXT)
		)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist

	enewgroup minetest
	enewuser minetest -1 -1 /var/lib/minetest "minetest,games"
	doinitd "${FILESDIR}/minetestserver.init"
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update

	if ! use dedicated ; then
		elog "optional dependencies:"
		elog "	games-action/minetest_game (official mod)"
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
