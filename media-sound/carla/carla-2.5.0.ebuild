# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9,10} )
inherit python-single-r1 toolchain-funcs xdg

DESCRIPTION="Full featured audio plugin host supporting many audio drivers and plugin formats"
HOMEPAGE="https://kx.studio/Applications:Carla"

# Credit to https://gitlab.com/yemou/moulay

if [[ ${PV} == 9999 ]]
then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/falkTX/${PN}"
else
	SRC_URI="https://github.com/falkTX/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P/c/C}"
fi

LICENSE="GPL-2+ LGPL-3"
SLOT="0"
IUSE="+X alsa +gtk gtk2 +juce osc +opengl pulseaudio +qt5 rdf +sdl sf2 +sndfile"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	juce? ( X )
	opengl? ( X )
"

# TODO:
# - virtual/jack depends on a Makefile option
# - x11-libs/gtk+:3 ???
RDEPEND="
	${PYTHON_DEPS}
	X? (
		juce? (
			media-libs/freetype:2
		)
		x11-libs/libX11
		media-libs/libglvnd
	)
	alsa? ( media-libs/alsa-lib )
	gtk2? ( x11-libs/gtk+:2 )
	gtk? ( x11-libs/gtk+:3 )
	pulseaudio? ( media-libs/libpulse )
	qt5? (
		$(python_gen_cond_dep 'dev-python/PyQt5[gui,svg,widgets,${PYTHON_USEDEP}]')
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	rdf? ( $(python_gen_cond_dep 'dev-python/rdflib[${PYTHON_USEDEP}]') )
	sdl? ( media-libs/libsdl2 )
	sf2? ( media-sound/fluidsynth:= )
	sndfile? ( media-libs/libsndfile )
	sys-apps/file
"

# TODO: is x11-base/xorg-proto necessary?
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}/clang-fno-gnu-unique.patch" )

src_prepare() {
	sed -i -e "3s|=.*|=${PYTHON}|; 4,7d" \
		data/carla \
		data/carla-bridge-lv2-modgui \
		data/carla-control \
		data/carla-database \
		data/carla-jack-multi \
		data/carla-jack-single \
		data/carla-patchbay \
		data/carla-rack \
		data/carla-settings || die "sed failed"

	default
}

src_compile() {
	myemakeargs=(
		CLANG=$(tc-is-clang && echo true || echo false)
		HAVE_ALSA=$(usex alsa true false)
		HAVE_DGL=$(usex opengl true false)
		HAVE_FLUIDSYNTH=$(usex sf2 true false)
		HAVE_GTK2=$(usex gtk2 true false)
		HAVE_GTK3=$(usex gtk true false)
		HAVE_LIBLO=$(usex osc true false)
		HAVE_PULSEAUDIO=$(usex pulseaudio true false)
		HAVE_PYQT=$(usex qt5 true false)
		HAVE_QT5=$(usex qt5 true false)
		HAVE_SDL2=$(usex sdl true false)
		HAVE_SNDFILE=$(usex sndfile true false)
		HAVE_X11=$(usex X true false)
		LIBDIR="/usr/$(get_libdir)"
		SKIP_STRIPPING=true
		USING_JUCE=$(usex juce true false)
	)

	emake PREFIX="${EPREFIX}/usr" "${myemakeargs[@]}" features
	emake PREFIX="${EPREFIX}/usr" "${myemakeargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" "${myemakeargs[@]}" install
}
