# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Hosting library and audio plugin for JSFX"
HOMEPAGE="https://github.com/jpcima/ysfx"
KEYWORDS="~amd64"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/jpcima/ysfx"
	EGIT_BRANCH="master"
else
	:
#	SRC_URI="https://github.com/jpcima/${PN}/releases/download/${PV}/${PN}-src-${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="lto"

RDEPEND="
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	"
DEPEND="
	${RDEPEND}
"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DYSFX_PLUGIN_LTO=$(usex lto 1 0)
		-DYSFX_PLUGIN_COPY=0
	)

	cmake_src_configure
}

src_install() {
	# cannot use dolib.so because helper would append libdir to target dir
	# This location is defined in the standard
	# https://steinbergmedia.github.io/vst3_dev_portal/pages/Technical+Documentation/Locations+Format/Plugin+Locations.html#on-linux-platform

	insinto /usr/lib/vst3
	insopts -m 0644
	doins -r "${BUILD_DIR}"/ysfx_plugin_artefacts/*/VST3/ysfx.vst3

	cmake_src_install
}
