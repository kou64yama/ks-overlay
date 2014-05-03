# Copyright 1999-2012 Gentoo Foundation
# Distribute under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit multilib toolchain-funcs

DESCRIPTION="Open source command-line RTMP client intended to stream audio or video flash content"
HOMEPAGE="http://rtmpdump.mplayerhq.hu/"
SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz"

# the library is LGPL-2.1, the command is GPL-2
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x64-macos ~x86-macos"
IUSE="gnutls polarssl ssl"

DEPEND="ssl? (
		gnutls? ( net-libs/gnutls )
		polarssl? ( !gnutls? ( >=net-libs/polarssl-0.14.0 ) )
		!gnutls? ( !polarssl? ( dev-libs/openssl ) )
	)
	sys-libs/zlib"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! use ssl && ( use gnutls || use polarssl ); then
		ewarn "USE='gnutls polarssl' are ignored without USE='ssl'."
		ewarn "Please review the local USE flags for this package."
	fi
}

src_prepare() {
	# fix Makefile ( bug #298535 , bug 3318353 and bug #324513 )
	sed -i 's/\$(MAKEFLAGS)//g' Makefile \
		|| die "failed to fix Makefile"
	sed -i -e 's:OPT=:&-fPIC :' \
		-e 's:OPT:OPTS:' \
		-e 's:CFLAGS=.*:& $(OPT):' \
		-e 's:-headerpad_max_install_names:-headerpad_max_install_names -install_name $(libdir)/$@:' librtmp/Makefile \
		|| die "failed to fix Makefile"
}

src_compile() {
	if use ssl ; then
		if use gnutls ; then
			crypto="GNUTLS"
		elif use polarssl ; then
			crypto="POLARSSL"
		else
			crypto="OPENSSL"
		fi
	fi
	#fix multilib-script support. Bug #327449
	sed -i "/^libdir/s:lib$:$(get_libdir)$:" librtmp/Makefile
	local sys=posix
	if [ $ARCH = "x86-macos" -o $ARCH = "x64-macos" ]; then
		sys=darwin
	fi
	emake CC=$(tc-getCC) LD=$(tc-getLD) \
		OPT="${CFLAGS}" XLDFLAGS="${LDFLAGS}" CRYPTO="${crypto}" SYS="${sys}" prefix="${EPREFIX}/usr"
}

src_install() {
	mkdir -p "${D}"/${EPREFIX}${DESTTREE}/$(get_libdir)
	local sys=posix
	if [ $ARCH = "x86-macos" -o $ARCH = "x64-macos" ]; then
		sys=darwin
	fi
	emake DESTDIR="${D}" prefix="${EPREFIX}${DESTTREE}" mandir="${EPREFIX}${DESTTREE}/share/man" \
	CRYPTO="${crypto}" SYS="${sys}" install
	dodoc README ChangeLog rtmpdump.1.html rtmpgw.8.html
}
