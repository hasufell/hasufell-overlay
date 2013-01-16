# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
WX_GTK_VER="2.8"
inherit eutils wxwidgets games

DESCRIPTION="Zod engine is a remake of the 1996 classic game by Bitmap Brothers called Z"
HOMEPAGE="http://zod.sourceforge.net/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+editor +launcher"

RESTRICT="bindist fetch"

RDEPEND="
	media-libs/libsdl[X,audio,video]
	media-libs/sdl-ttf[X]
	media-libs/sdl-mixer[mp3,timidity,vorbis,wav]
	media-libs/sdl-image[png]
	virtual/mysql
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/zod_engine

pkg_nofetch() {
	einfo "Please download zod_linux-2011-09-06.tar.gz from:"
	einfo "http://sourceforge.net/projects/zod/files/linux_releases/"
	einfo "and move it to ${DISTDIR}"
	echo
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-{proper-linux-support,build}.patch

	# remove unused files
	find "${S}" -type f \( -name Thumbs.db -o -name "*.xcf" -o -name "*.ico" \) -delete || die
	rm assets/{splash.png,WebCamScene.icescene} || die
}

src_compile() {
	emake -C zod_src DATA_PATH="\"${GAMES_DATADIR}/${PN}\"" main $(usex editor "map_editor" "")
	use launcher && emake -C zod_launcher_src DATA_PATH="\"${GAMES_DATADIR}/${PN}\""
}

src_install() {
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r assets blank_maps *.map default_settings.txt *map_list.txt
	dogamesbin zod_src/zod
	dodoc zod_engine_help.txt

	if use editor ; then
		dogamesbin zod_src/zod_map_editor
		dodoc map_editor_help.txt
	fi

	if use launcher ; then
		dogamesbin zod_launcher_src/zod_launcher
		newicon assets/icon.png ${PN}.png
		make_desktop_entry zod_launcher "Zod Engine"
	fi

	prepgamesdirs
}
