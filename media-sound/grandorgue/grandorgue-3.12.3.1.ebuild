# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="GrandOrgue is a sample based pipe organ simulator"
HOMEPAGE="https://github.com/GrandOrgue/grandorgue"
PV_=${PV%.*}-${PV##*.}
SRC_URI="https://github.com/GrandOrgue/grandorgue/archive/refs/tags/${PV_}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV_}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa demo jack"

# rtmidi should be :=, but does not define slot ...
DEPEND="
	dev-cpp/yaml-cpp:=
	media-libs/portaudio[alsa?,jack?]
	media-libs/rtaudio:=[alsa?,jack?]
	media-libs/rtmidi[alsa?,jack?]
	media-libs/zita-convolver:=
	media-sound/wavpack
	sys-libs/zlib
	virtual/jack
	x11-libs/wxGTK:3.0-gtk3
	"
RDEPEND="${DEPEND}"
BDEPEND="
	app-arch/zip
	app-text/po4a
	dev-libs/libxslt
	media-gfx/imagemagick
	sys-devel/gettext
	sci-libs/fftw
	"

src_configure() {
	local mycmakeargs=(
		-DUSE_INTERNAL_RTAUDIO=0
		-DUSE_INTERNAL_PORTAUDIO=0
		-DUSE_INTERNAL_ZITACONVOLVER=0
		-DINSTALL_DEMO=$(usex demo 1 0)
		-DUSE_BUILD_SYSTEM_LIBDIR=1
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# This silents a warning at startup.
	keepdir /usr/share/GrandOrgue/packages
}
