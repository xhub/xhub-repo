# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake xdg

RESTRICT="mirror"
QTMIN=6.6.2
KFMIN=6.3.0

HOTSPOT_REV=b61451d827dd23e35c5f611e3626226a119dfa48
PERFPARSER_REV=65472541f74da213583535c8bb4fea831e875109

MY_PV=${PV%_p*}

DESCRIPTION="The Linux perf GUI for performance analysis."
HOMEPAGE="https://github.com/KDAB/hotspot"
SRC_URI="
	https://github.com/KDAB/hotspot/archive/${HOTSPOT_REV}.tar.gz -> ${PN}-${HOTSPOT_REV}.tar.gz
	https://github.com/KDAB/perfparser/archive/${PERFPARSER_REV}.tar.gz -> ${PN}-perfparser-${PERFPARSER_REV}.tar.gz
	https://github.com/KDAB/hotspot/releases/download/v${MY_PV}/${PN}-PrefixTickLabels-v${MY_PV}.tar.gz -> ${PN}-v${MY_PV}-PrefixTickLabels.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
REQUIRE_USE=""

RDEPEND="
	app-arch/zstd:=
	dev-qt/qtbase:6=[network,widgets]
	dev-qt/qtsvg:6=
	dev-util/perf
	gui-libs/kddockwidgets:=
	>=kde-frameworks/extra-cmake-modules-${KFMIN}
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
	>=kde-frameworks/threadweaver-${KFMIN}:6
	sys-devel/binutils
	sys-devel/gettext
	virtual/libelf:=
	"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${HOTSPOT_REV}"

src_unpack() {
	unpack ${PN}-${HOTSPOT_REV}.tar.gz
	tar -xf "${DISTDIR}/${PN}-perfparser-${PERFPARSER_REV}.tar.gz" --strip-components=1 -C "${S}/3rdparty/perfparser" || die
	tar -xf "${DISTDIR}/${PN}-v${MY_PV}-PrefixTickLabels.tar.gz" --strip-components=1 -C "${S}/3rdparty/PrefixTickLabels" || die
}

src_prepare() {
	# Gentoo doesn't support debuginfod, Hotspot doesn't have an option to disable that yet.
	sed -i '/LIBDEBUGINFOD_LIBRARIES/d' 3rdparty/perfparser.cmake \
			|| die "sed failed for perfparser"

	eapply_user
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DQT6_BUILD=true
	)
	cmake_src_configure
}

