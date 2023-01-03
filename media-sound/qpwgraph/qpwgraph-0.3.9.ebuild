# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt GUI to control the pipewire and ALSA sequencer connections"
HOMEPAGE="https://gitlab.freedesktop.org/rncbc/qpwgraph"
SRC_URI="https://gitlab.freedesktop.org/rncbc/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+alsa debug +systray"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-video/pipewire:=
	alsa? ( media-libs/alsa-lib )
	systray? ( dev-qt/qtnetwork:5 )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCONFIG_ALSA_MIDI=$(usex alsa 1 0)
		-DCONFIG_DEBUG=$(usex debug 1 0)
		-DCONFIG_SYSTEM_TRAY=$(usex systray 1 0)
		-DCONFIG_WAYLAND=0
		-DCONFIG_QT6=0
	)
	cmake_src_configure
}
