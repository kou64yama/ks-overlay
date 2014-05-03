# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils user java-pkg-2 java-ant-2

DESCRIPTION="GitBucket is the easily installable Github clone written with Scala."
HOMEPAGE="https://github.com/takezoe/gitbucket"
SRC_URI="https://github.com/takezoe/${PN}/archive/${PV}.tar.gz"
#SRC_URI="https://github.com/takezoe/${PN}/releases/download/${PV}/${PN}.war"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

SCALA_VERSION="2.10"
TARGET_VERSION="2.10-0.0.1"

GITBUCKET_USER="gitbucket"
DATA_DIR="/var/lib/gitbucket"

pkg_setup() {
	enewgroup ${GITBUCKET_USER}
	enewuser ${GITBUCKET_USER} -1 /bin/bash ${DATA_DIR} "${GITBUCKET_USER}"
}

src_compile() {
	eant embed
}

src_install() {
	mv target/scala-${SCALA_VERSION}/${PN}_${TARGET_VERSION}.war target/${PN}.war
	java-pkg_dowar target/${PN}.war
	newinitd "${FILESDIR}/init-gitbucket.sh" gitbucket
	newconfd "${FILESDIR}/conf-gitbucket.conf" gitbucket
}
