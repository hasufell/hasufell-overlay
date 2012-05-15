# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WX_GTK_VER="2.8"

inherit eutils wxwidgets games

MY_P="${PN}-r${PV%_*}-alpha"

DESCRIPTION="A free, real-time strategy game"
HOMEPAGE="http://wildfiregames.com/0ad/"
SRC_URI="http://releases.wildfiregames.com/${MY_P}-unix-build.tar.xz"

LICENSE="GPL-2 LGPL-2.1 MIT CCPL-Attribution-ShareAlike-3.0 as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+audio editor fam pch test"

RDEPEND="
	~dev-lang/spidermonkey-1.8.5
	dev-libs/boost
	dev-libs/libxml2
	~games-strategy/0ad-data-${PV}
	media-gfx/nvidia-texture-tools
	media-libs/libpng:0
	media-libs/libsdl[X,opengl,video]
	net-libs/enet:1.3
	net-misc/curl
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	x11-libs/libX11
	audio? ( media-libs/libogg
		media-libs/libvorbis
		media-libs/openal )
	editor? ( x11-libs/wxGTK:${WX_GTK_VER}[X,opengl] )
	fam? ( virtual/fam )
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-lang/perl )"

S=${WORKDIR}/${MY_P}

src_configure() {
	cd build/workspaces || die

	./update-workspaces.sh \
		--with-system-nvtt \
		--with-system-enet \
		--with-system-mozjs185 \
		$(usex fam "" "--without-fam") \
		$(usex pch "" "--without-pch") \
		$(usex test "" "--without-tests") \
		$(usex audio "" "--without-audio") \
		$(use_enable editor atlas) \
		--bindir="${GAMES_BINDIR}" \
		--libdir="$(games_get_libdir)"/${PN} \
		--datadir="${GAMES_DATADIR}"/${PN}
}

src_compile() {
	emake -C build/workspaces/gcc verbose=1 || die
}

src_test() {
	cd binaries/system || die
	./test || die "test phase failed"
}

src_install() {
	dogamesbin binaries/system/pyrogenesis || die

	exeinto "$(games_get_libdir)"/${PN}
	doexe binaries/system/libCollada.so || die
	if use editor ; then
		doexe binaries/system/libAtlasUI.so || die
	fi

	dodoc binaries/system/readme.txt
	doicon build/resources/${PN}.png
	games_make_wrapper ${PN} "${GAMES_BINDIR}/pyrogenesis"
	make_desktop_entry ${PN}

	prepgamesdirs
}
