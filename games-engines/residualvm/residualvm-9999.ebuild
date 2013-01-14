# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils toolchain-funcs gnome2-utils git-2 games

DESCRIPTION="A cross-platform 3D game interpreter for play LucasArts' LUA-based 3D adventures"
HOMEPAGE="http://www.residualvm.org/"
EGIT_REPO_URI="git://github.com/residualvm/residualvm.git"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

# TODO: fix dynamic plugin support
# games crash without media-libs/libsdl[alsa]
RDEPEND="
	media-libs/alsa-lib
	media-libs/freetype:2
	media-libs/libsdl[X,audio,alsa,joystick,opengl,video]
	sys-libs/zlib
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"

src_unpack() {
	git-2_src_unpack
}

src_configure() {
	# not an autotools script
	# most configure options currently do nothing, recheck on version bump !!!
	# disable explicitly, otherwise we get unneeded linkage (some copy-paste build system)
	./configure \
		--disable-debug \
		--enable-all-engines \
		--backend=sdl \
		--enable-release-mode \
		--disable-tremor \
		--disable-sparkle \
		--prefix="${GAMES_PREFIX}" \
		--datadir="${GAMES_DATADIR}/${PN}" \
		--libdir="$(games_get_libdir)" \
		--docdir="/usr/share/doc/${PF}" \
		--disable-libunity \
		--enable-zlib \
		|| die "configure failed"
}

src_compile() {
	emake \
		VERBOSE_BUILD=1 \
		AR="$(tc-getAR) cru" \
		RANLIB=$(tc-getRANLIB)
}

src_install() {
	dogamesbin residualvm

	insinto "${GAMES_DATADIR}/${PN}"
	doins gui/themes/modern.zip dists/engine-data/residualvm-grim-patch.lab

	doicon -s scalable icons/${PN}.svg
	doicon -s 256 icons/${PN}.png
	domenu dists/${PN}.desktop

	doman dists/${PN}.6
	dodoc AUTHORS README KNOWN_BUGS TODO

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
