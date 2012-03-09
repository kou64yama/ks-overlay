#

EAPI="4"

inherit versionator elisp-common ruby

MY_PV=$(replace_version_separator 1 '_')

DESCRIPTION="Functions for editing Evernote notes directly from Emacs"
HOMEPAGE="http://code.google.com/p/emacs-evernote-mode/"
LICENSE="Apache-2.0"

SRC_URI="http://emacs-evernote-mode.googlecode.com/files/${PN}-${MY_PV}.zip"
SLOT="0"
KEYWORDS="~amd64"

IUSE="doc w3m"

DEPEND="
w3m? ( app-emacs/emacs-w3m )
>=virtual/emacs-22
>=dev-lang/ruby-1.8.7[gdbm]
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_compile() {
	ruby_src_compile "$@"
	elisp-compile evernote-mode.el || die
}

src_install() {

	use doc && dodoc doc/*
	elisp-install ${PN} evernote-mode.el *.elc || die

	RUBY_ECONF="${RUBY_ECONF} ${EXTRA_ECONF}"
	${RUBY} ruby/setup.rb config --prefix=/usr "$@" \
		${RUBY_ECONF} || die "setup.rb config failed"
	${RUBY} ruby/setup.rb install --prefix="${D}" "$@" \
		${RUBY_ECONF} || die "setup.rb install failed"

}

# Local variables:
# mode: shell-script;
# indent-tabs-mode: t;
# tab-width: 4;
# End:
