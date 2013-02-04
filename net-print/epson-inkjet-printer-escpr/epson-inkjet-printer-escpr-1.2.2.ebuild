# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Epson Inkjet Printer Driver (ESC/P-R) for Linux"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="${P}-1lsb3.2.tar.gz"
RESTRICT="fetch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

pkg_nofetch() {
	[ -z "${SRC_URI}" ] && return

	einfo "Please download"
	einfo "  - ${SRC_URI}"
	einfo "from ${HOMEPAGE} and place them in ${DISTDIR}"
}
