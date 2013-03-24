# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils eutils gnome2-utils mercurial games

EHG_REPO_URI="https://bitbucket.org/sumwars/sumwars-code"
EHG_REVISION="default"
EHG_PROJECT="${PN}"

DESCRIPTION="a multi-player, 3D action role-playing game"
HOMEPAGE="http://sumwars.org"
SRC_URI=""

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS=""
IUSE="+tools debug"

LANGS="de en it pl pt ru uk"
for L in ${LANGS} ; do
	IUSE="${IUSE} linguas_${L}"
done
unset L

DEPEND="
	>=dev-games/cegui-0.7.6-r1[ogre]
	!>=dev-games/cegui-0.8
	>=dev-games/ogre-1.7.0[freeimage,opengl,-threads]
	!>=dev-games/ogre-1.9
	dev-games/ois
	dev-games/physfs
	=dev-lang/lua-5.1*
	>=dev-libs/tinyxml-2.6.2-r2
	media-libs/freealut
	media-libs/openal
	media-libs/libogg
	media-libs/libvorbis
	>=net-libs/enet-1.3.0
	x11-libs/libXrandr
	tools? ( dev-libs/poco )"

pkg_setup() {
	ewarn "Orge3D currently doesn't work with USE-flag 'threads' under some circumstances."
	ewarn "If you experience a problem running $P please rebuild dev-games/ogre with USE -threads."
	ewarn "See https://bugs.gentoo.org/show_bug.cgi?id=307205#c25"
	games_pkg_setup
}

src_unpack() {
	mercurial_src_unpack
}

src_configure() {
	use debug && CMAKE_BUILD_TYPE=Debug

	local l langs
	for l in ${LANGS}; do
		if use linguas_${l}; then
			langs="${langs} ${l}"
		fi
	done

	[ -z "${langs}" ] && langs="en"

	# configure sumwars with cmake
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=""
		-DSUMWARS_LANGUAGES="${langs}"
		-DSUMWARS_NO_TINYXML=ON
		-DSUMWARS_NO_ENET=ON
		-DSUMWARS_DOC_DIR="/usr/share/doc/${PF}"
		-DSUMWARS_EXECUTABLE_DIR="${GAMES_BINDIR}"
		-DSUMWARS_SHARE_DIR="${GAMES_DATADIR}/${PN}"
		-DSUMWARS_STANDALONE_MODE=OFF
		-DSUMWARS_POST_BUILD_COPY=OFF
		-DSUMWARS_PORTABLE_MODE=OFF
		-DSUMWARS_RANDOM_REGIONS=ON
		$(cmake-utils_use tools SUMWARS_BUILD_TOOLS)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	insinto /usr/share/icons/hicolor/128x128/apps
	newins share/icon/SumWarsIcon_128x128.png ${PN}.png
	make_desktop_entry ${PN} "Summoning Wars"
	prepalldocs
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
