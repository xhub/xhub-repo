# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="GrandOrgue is a sample based pipe organ simulator"
HOMEPAGE="https://github.com/GrandOrgue/grandorgue"
PV_=${PV%.*}-${PV##*.}
SRC_URI="https://github.com/GrandOrgue/grandorgue/archive/refs/tags/${PV_}.tar.gz"
S="${WORKDIR}/${PN}-${PV_}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa demo jack"

DEPEND="
	media-libs/portaudio[alsa?,jack?]
	media-libs/rtaudio:=[alsa?,jack?]
	media-libs/rtmidi[alsa?,jack?]
	media-libs/zita-convolver:=
	media-sound/wavpack
	sci-libs/fftw
	sys-libs/zlib
	virtual/jack
	x11-libs/wxGTK
	"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-3.7.0.1-fix-hardcoded-libdir.patch"
)

src_configure() {
	local mycmakeargs=(
		-DUSE_INTERNAL_RTAUDIO=0
		-DUSE_INTERNAL_PORTAUDIO=0
		-DUSE_INTERNAL_ZITACONVOLVER=0
		-DINSTALL_DEMO=$(usex demo 1 0)
	)
	cmake_src_configure
}
