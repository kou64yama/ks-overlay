# -*- indent-tabs-mode: t; tab-width: 4; -*-
# Copyright 2011 Koji Yamada
# Distributed under the terms of the GNU General Public License v2
# $Header:$

EAPI="4"
inherit base

DESCRIPTION=""
HOMEPAGE="http://dropbox.com/"
SRC_URI="x86?   ( http://dl-web.dropbox.com/u/17/${PN}-lnx.x86-${PV}.tar.gz )
         amd64? ( http://dl-web.dropbox.com/u/17/${PN}-lnx.x86_64-${PV}.tar.gz )"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT=""

QA_EXECSTACK_x86="opt/${PN}/_ctype.so"
QA_EXECSTACK_amd64="opt/${PN}/_ctype.so"

DEPEND=""
RDEPEND="net-misc/wget"

S="${WORKDIR}/.dropbox-dist"

src_install() {

	local prefix="${EPREFIX}/opt/${PN}"

	insinto "${prefix}"
	doins -r *
	fperms a+x "${prefix}/dropbox"
	fperms a+x "${prefix}/dropboxd"

	newinitd "${FILESDIR}/init-${PV}" "${PN}d"
	newconfd "${FILESDIR}/conf-${PV}" "${PN}d"

}
