# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils xdg

DESCRIPTION="Digital keyboard workstation"
HOMEPAGE="https://www.noedig.co.za/konfyt/"
SRC_URI="https://github.com/noedigcode/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/liblscp
	media-sound/carla
	media-sound/fluidsynth:=
	virtual/jack
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	eqmake5
}

src_install() {
	dobin ${PN}

	domenu desktopentry/${PN}.desktop
	doicon -s 128 desktopentry/${PN}.png
}
