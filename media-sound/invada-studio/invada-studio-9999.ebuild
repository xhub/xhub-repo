# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Invada studio is a collection of audio LV2 open-source plugins"
HOMEPAGE="https://github.com/xhub/invada-studio"
if [[ ${PV} == *9999 ]];then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xhub/${PN}"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/xhub/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/glib:2
	media-libs/lv2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default_src_prepare

	# Use compiler driver rather than LD as LDFLAGS is passed as arugment
	sed -i -e 's:$(LD):$(CC):' plugingui/Makefile ./plugin/Makefile || die 'sed failed'
}

src_install() {
	emake DESTDIR="${ED}" INSTALL_SYS_PLUGINS_DIR=/usr/$(get_libdir)/lv2 install-sys
}
