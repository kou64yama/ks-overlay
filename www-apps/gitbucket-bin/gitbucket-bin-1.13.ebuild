# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils user

DESCRIPTION="GitBucket is the easily installable Github clone written with Scala."
HOMEPAGE="https://github.com/takezoe/gitbucket"
SRC_URI="https://github.com/takezoe/gitbucket/releases/download/${PV}/gitbucket.war"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tomcat ldap"

RDEPEND="
	>=virtual/jre-1.5
	tomcat? ( www-servers/tomcat )
	ldap? ( net-nds/openldap )"

GIT_USER="git"
GIT_HOME="/var/lib/git"

pkg_setup() {
	enewgroup ${GIT_USER}
	enewuser ${GIT_USER} -1 /bin/bash ${GIT_HOME} "${GIT_USER}"
}

src_unpack() {
	mkdir -p ${S}
	cp "${DISTDIR}/${A}" "${S}"
}

src_install() {
	insinto "/usr/lib/${PN}"
	newins "${S}/gitbucket.war" gitbucket.war
	newinitd "${FILESDIR}/init-gitbucket.sh" gitbucket
	newconfd "${FILESDIR}/conf-gitbucket.conf" gitbucket
}

pkg_postinst() {
	local git_home=$(egethome ${GIT_USER})
	elog "Initlaizing home directory"
	mkdir -p ${git_home}
	chown -R ${GIT_USER}:${GIT_USER} ${git_home}

	if use tomcat; then
		elog "Please unpack /var/lib/gitbucket/gitbucket.war in to your servlet container!"
		elog "If it is an update, delete the old content first!"
	fi

	elog
	elog "GitBucket was initialized. Repositories are located in"
	elog "${GIT_HOME}/repositories."
}
