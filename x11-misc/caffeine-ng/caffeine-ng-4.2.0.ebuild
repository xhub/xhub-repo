# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Taken from pf4public which originates from Jorgicio's overlay

EAPI=8

PYTHON_COMPAT=( python3_11 )

inherit python-single-r1 gnome2-utils meson xdg

DESCRIPTION="Application able to temporarily inhibit the screensaver"
HOMEPAGE="https://codeberg.org/WhyNotHugo/caffeine-ng"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	#EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="https://codeberg.org/WhyNotHugo/caffeine-ng/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S=${WORKDIR}/${PN}
fi

LICENSE="GPL-3"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep \
		'dev-python/pygobject:3[${PYTHON_USEDEP}]
		 >=dev-python/pyxdg-0.25[${PYTHON_USEDEP}]
		 dev-python/dbus-python[${PYTHON_USEDEP}]
		 >=dev-python/docopt-0.6.2[${PYTHON_USEDEP}]
		 >=dev-python/ewmh-0.1.4[${PYTHON_USEDEP}]
		 >=dev-python/setproctitle-1.1.10[${PYTHON_USEDEP}]
		 dev-python/setuptools[${PYTHON_USEDEP}]
		 >=dev-python/wheel-0.29.0[${PYTHON_USEDEP}]
		 dev-python/setuptools-scm[${PYTHON_USEDEP}]
	     dev-python/pulsectl[${PYTHON_USEDEP}]
		 dev-python/click[${PYTHON_USEDEP}]')
	dev-libs/libappindicator:3[introspection]
	x11-libs/gtk+:3
	x11-libs/libnotify[introspection]
"
RDEPEND="${DEPEND}"

BDEPEND="
	${DEPEND}
	app-text/scdoc"

src_prepare() {
	sed "s/;TrayIcon;DesktopUtility//" -i share/applications/caffeine.desktop || die
	echo "${PV}" > version

	default
}

src_install() {
	meson_install

	python_fix_shebang "${D}"/usr/bin/caffeine
}

pkg_postinst() {
	gnome2_gconf_install
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_gconf_uninstall
	gnome2_schemas_update
	xdg_pkg_postrm
}
