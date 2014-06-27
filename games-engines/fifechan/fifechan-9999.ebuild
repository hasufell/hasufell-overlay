# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-2

DESCRIPTION="Lightweight cross platform GUI library written in C++ specifically designed for games"
HOMEPAGE="http://fifengine.github.io/fifechan/"
SRC_URI=""

EGIT_REPO_URI="git://github.com/fifengine/fifechan.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="+allegro +opengl ogftl +sdl sdl_ttf"

DEPEND="allegro? ( media-libs/allegro:5 )
		opengl? ( virtual/opengl
			virtual/glu )
		sdl? ( media-libs/libsdl
			media-libs/sdl-image[png] )
		sdl_ttf? ( media-libs/sdl-ttf )
		x11-libs/libXext"
RDEPEND="${DEPEND}"

REQUIRED_USE="ogftl? ( opengl )
			sdl_ttf? ( sdl )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_ues_enable allegro ENABLE_ALLEGRO)
		$(cmake-utils_use_enable sdl ENABLE_SDL)
		$(cmake-utils_use_enable sdl_ttf ENABLE_SDL_CONTRIB)
		$(cmake-utils_ues_enable opengl ENABLE_OPENGL)
		$(cmake-utils_ues_enable ogftl ENABLE_OPENGL_CONTRIB)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
