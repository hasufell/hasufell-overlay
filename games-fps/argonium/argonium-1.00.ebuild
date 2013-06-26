# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils games

DESCRIPTION="Multiplayer FPS powered by iD Software's Quake 2 engine"
HOMEPAGE="http://www.planetquake.com/td/argonium/"

I_SRC="http://icculus.org/~ravage/${PN}"
SRC_URI="${I_SRC}/${P}-i386.tar.gz
	${I_SRC}/${PN}_${PV}_src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/alsa-lib
	virtual/opengl"

S=${WORKDIR}/${PN}_src

src_compile() {
	epatch "${FILESDIR}"/${P}-QA.patch \
		"${FILESDIR}"/${P}-return-value.patch \
		"${FILESDIR}"/${P}-static-declaration.patch

	# Keep the directory names simple
	sed -i \
		-e 's/debug$(ARCH)/build/' \
		-e 's/release$(ARCH)/build/' \
		linux/Makefile || die "sed failed"

	emake -C linux \
		CC="${CC}$(usex amd64 " -m32" "")" \
		build_release
}

src_install() {
	local dir=${GAMES_DATADIR}/${PN}

	exeinto "${dir}"
	doexe linux/build/{argonium,refresh.so}
	exeinto "${dir}"/data
	doexe linux/build/runtime*.so

	# Data files
	insinto "${dir}"
	cd "${WORKDIR}"/${PN}
	rm -f argonium *.so data/*.so
	dodoc README.Linux *.txt && rm README.Linux *.txt

	doins -r *

	games_make_wrapper ${PN} ./${PN} "${dir}" "${dir}"
	make_desktop_entry ${PN} Argonium

	prepgamesdirs
}
