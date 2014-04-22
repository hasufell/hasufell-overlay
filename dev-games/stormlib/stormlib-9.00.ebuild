# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib cmake-utils vcs-snapshot

DESCRIPTION="Open-source lib that can work with Blizzard MPQ archives"
HOMEPAGE="http://www.zezula.net/mpq.html"
SRC_URI="https://github.com/wheybags/StormLib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

RDEPEND="
	app-arch/bzip2
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i \
		-e "/LIBRARY DESTINATION/s# lib # $(get_libdir) #" \
		CMakeLists.txt || die "failed fixing libdir"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with static STATIC)
	)

	cmake-utils_src_configure
}
