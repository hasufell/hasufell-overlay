# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-2

DESCRIPTION="Lightweight cross platform GUI library written in C++ specifically designed for games"
HOMEPAGE="http://fifengine.github.io/fifechan/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/fifengine/fifechan.git"
LICENSE="LGPL 2.1"
SLOT="0"
KEYWORDS=""
IUSE="allegro opengl sdl"

DEPEND="x11-libs/libXext
		media-libs/libsdl
		sdl? ( media-libs/sdl-ttf )
		media-libs/sdl-image[png]
		opengl? ( virtual/opengl
				virtual/glu )
		allegro? ( media-libs/allegro )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable sdl ENABLE_SDL_CONTRIB)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
