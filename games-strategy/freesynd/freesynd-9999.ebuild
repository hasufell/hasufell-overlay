# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils eutils subversion games

DESCRIPTION="A cross-platform reimplementation of engine for the classic Bullfrog game, Syndicate"
HOMEPAGE="http://freesynd.sourceforge.net/"
ESVN_REPO_URI="svn://svn.code.sf.net/p/freesynd/code/freesynd/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="media-libs/libogg
	media-libs/libpng:0
	media-libs/libsdl[X,audio,video]
	media-libs/libvorbis
	media-libs/sdl-mixer[mp3,vorbis]
	media-libs/sdl-image[png]"
DEPEND="${RDEPEND}"

CMAKE_IN_SOURCE_BUILD=1

src_prepare() {
	sed \
		-e "s:#freesynd_data_dir = /usr/share/freesynd/data:freesynd_data_dir = ${GAMES_DATADIR}/${PN}/data:" \
		-i ${PN}.ini || die
}

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dogamesbin src/${PN} || die
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data || die
	newicon icon/sword.png ${PN}.png || die
	make_desktop_entry ${PN} ${PN} ${PN}
	dodoc NEWS README INSTALL AUTHORS || die
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "You have to set \"data_dir = /my/path/to/synd-data\""
	elog "in \"~/.${PN}/${PN}.ini\"."
}
