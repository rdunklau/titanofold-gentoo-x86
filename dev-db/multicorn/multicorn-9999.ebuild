# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python{2_{6,7},3_3} )
POSTGRES_COMPAT=( 9.{2,3} )

inherit git-2 flag-o-matic postgres distutils-r1

MY_PN="Multicorn"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A PostgreSQL extension for foreign data access"
HOMEPAGE="http://multicorn.org"
EGIT_REPO_URI="git://github.com/Kozea/${MY_PN}.git"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="dev-db/postgresql-server[python]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/Makefile.patch"
	postgres_src_prepare || die
}

src_compile(){
	postgres_src_compile || die
	postgres_foreach_impl run_in_build_dir distutils-r1_src_compile ${PN} || die
}

src_install() {
	postgres_src_install || die
	postgres_foreach_impl run_in_build_dir distutils-r1_src_install ${PN} || die
}
