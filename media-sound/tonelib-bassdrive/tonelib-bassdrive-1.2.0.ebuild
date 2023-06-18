# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="Bass drive pedal emulation"
HOMEPAGE="https://tonelib.net/tl-bassdrive.html"
APPNAME="ToneLib-BassDrive"
SRC_URI="https://www.tonelib.net/download/${APPNAME}-amd64.deb"
S="${WORKDIR}"

LICENSE="all-rights-reserved"  # unsure
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="*"
RESTRICT="mirror bindist strip"

DEPEND="
	media-libs/alsa-lib
	media-libs/freetype
	media-libs/libglvnd"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	default
	sed -e "s!AudioEditing!X-&!" \
		-i usr/share/applications/${APPNAME}.desktop || die
}

src_install() {

	dobin usr/bin/${APPNAME} || die
	cp -ra usr/lib "${ED}"/usr/lib64 || die  # hardcoded amd64

	dodoc usr/share/doc/${PN}/copyright

	doicon usr/share/pixmaps/${APPNAME}.png

	local res
	for res in 16 24 32 48 64 96 128; do
		newicon -s ${res} usr/share/icons/hicolor/${res}x${res}/apps/${APPNAME}.png ${APPNAME}.png
	done

	domenu usr/share/applications/${APPNAME}.desktop

	cp -ra usr/share/mime "${ED}"/usr/share/mime || die
}
