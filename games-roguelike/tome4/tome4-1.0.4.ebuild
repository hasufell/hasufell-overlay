# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils multilib pax-utils games

MY_PN="t-engine4"
MY_PV="${PV/_/}"
MY_PV="${MY_PV/rc/RC}"
MY_P="${MY_PN}-src-${MY_PV}"
DESCRIPTION="Topdown tactical RPG roguelike game and game engine"
HOMEPAGE="http://te4.org"
SRC_URI="music? ( http://te4.org/dl/t-engine/${MY_P}.tar.bz2 )
	!music? ( http://te4.org/dl/t-engine/${MY_P}-nomusic.tar.bz2 )"

LICENSE="GPL-3 shockbolt-tileset"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+jit +music"

# TODO: unbundle some stuff
# http://forums.te4.org/viewtopic.php?f=42&t=38718
# TODO: use system fonts
RDEPEND="
	media-libs/libpng:0
	media-libs/libsdl2[X,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl2-image[png]
	media-libs/sdl2-ttf[X]
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}
	>=dev-util/premake-4.3:4"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# fix segfault on optimization levels higher than -O0
	# http://forums.te4.org/viewtopic.php?f=42&t=38712&p=161238
	epatch "${FILESDIR}"/tome4-1.0.4-qa.patch

	# fix broken sdl2 detection
	# http://forums.te4.org/viewtopic.php?f=42&t=38714
	sed -i \
		-e "s~/usr/lib32~/usr/$(get_abi_LIBDIR x86)~" \
		-e "s~/opt/SDL-2.0~/usr~" \
	     premake4.lua || die "premake sucks"
	sed -i \
		-e "s~/opt/SDL-2.0/lib/~/usr/$(get_libdir)~" \
	    build/te4core.lua || die "premake sucks"
}

src_configure() {
	local premake_options="--lua=$(usex jit "jit2" "default")"
	# Generate a "Makefile" with "premake4".
	einfo "Running \"premake4 ${premake_options} gmake\"..."
	premake4 ${premake_options} gmake

	# respect flags, remove misuse of $ARCH
	# files are generated, cannot patch
	sed -i \
		-e 's~\(CFLAGS\s*+= \).*~\1-MMD -MP $(DEFINES) $(INCLUDES)~' \
		-e 's~\(CXXFLAGS\s*+= \).*~\1-MMD -MP $(DEFINES) $(INCLUDES)~' \
		-e '/LDFLAGS/s~-s~~' \
		-e 's~$(ARCH) ~~' \
		build/*.make || die "premake sucks"

	# respect LDFLAGS
	# http://forums.te4.org/viewtopic.php?f=42&t=38715
	sed -i \
		-e 's~^[ \t]*LINKCMD.*$~LINKCMD = $(CC) $(CFLAGS) -o $(TARGET) $(OBJECTS) $(RESOURCES) $(LDFLAGS) $(LIBS)~' \
		build/{buildvm,minilua,TEngine}.make || die "premake sucks"
}

src_compile() {
	# parallel make broken
	# http://forums.te4.org/viewtopic.php?f=42&t=38713
	config='release' emake -j1 verbose=1
}

src_install() {
	local tome4_home="${GAMES_DATADIR}/${PN}"

	#FIXME: Ideally, "pax-mark m" should be prefixed with "use jit &&".
	#Disabling Lua JIT should permit PaX-hardened MPROTECT restrictions. It
	#doesn't, and it's not entirely clear why. Globally disable such
	#restrictions for now, until we get a better handle on what ToME4 is doing.

	# If enabling a Lua JIT interpreter, disable MPROTECT under PaX-hardened
	# kernels. (All Lua JIT interpreters execute in-memory code and hence cause
	# "Segmentation fault" errors under MPROTECT.)
	pax-mark m t-engine

	# does not respect FHS
	# http://forums.te4.org/viewtopic.php?f=42&t=38716
	games_make_wrapper "${PN}" "./t-engine" "${tome4_home}"

	dodoc CONTRIBUTING COPYING-TILES CREDITS

	insinto "${tome4_home}"
	doins -r bootstrap game
	exeinto "${tome4_home}"
	doexe t-engine

	prepgamesdirs
}
