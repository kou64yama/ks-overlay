# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI=4

[[ ${PV} == *9999 ]] && SCM="git-2"
EGIT_REPO_URI="git://git.sourceforge.jp/gitroot/${PN}/luatexja.git"

inherit latex-package ${SCM}

DESCRIPTION="LuaTeX において日本語組版を行うためのマクロを開発しようとするプロジェクトです．"
HOMEPAGE="http://sourceforge.jp/projects/luatex-ja/"
if [[ ${PV} != *9999 ]]; then
    SRC_URI=""
    KEYWORDS=""
else
    SRC_URI=""
    KEYWORDS=""
fi

LICENSE=""
SLOT="0"
IUSE="doc"

DEPEND="dev-texlive/texlive-luatex"
RDEPEND=""

src_install() {

    insinto /usr/share/texmf-site/tex/luatexja
    doins -r src/*

    insinto /usr/share/texmf-site/tex/luatexja/patches
    doins ${FILESDIR}/xunicode.sty

    if use doc; then
        docinto doc
        dodoc -r doc/*
    fi

}