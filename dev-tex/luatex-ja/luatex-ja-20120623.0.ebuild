# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI=4

# [[ ${PV} == *9999 ]] && SCM="git-2"
EGIT_REPO_URI="git://git.sourceforge.jp/gitroot/${PN}/luatexja.git"

inherit latex-package git-2

DESCRIPTION="LuaTeX において日本語組版を行うためのマクロを開発しようとするプロジェクトです．"
HOMEPAGE="http://sourceforge.jp/projects/luatex-ja/"
SRC_URI=""

if [[ ${PV} != *9999 ]]; then
    KEYWORDS="~amd64 ~x86 ~x64-macos ~x86-macos ~amd64-fbsd ~x86-fbsd"
    EGIT_COMMIT="${PV}"
else
    KEYWORDS=""
fi

LICENSE=""
SLOT="0"
IUSE="doc"

DEPEND="dev-texlive/texlive-luatex"
RDEPEND=""

src_install() {

    insinto /usr/share/texmf-dist/tex/luatex/luatexja
    doins -r src/*

    insinto /usr/share/texmf-dist/tex/luatex/luatexja/patches
    doins ${FILESDIR}/xunicode.sty

    if use doc; then
        docinto doc
        dodoc -r doc/*
    fi

}
