# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/snobol/snobol-1.1.ebuild,v 1.6 2012/11/27 19:41:40 ulm Exp $

EAPI=5

MY_P="${PN}4-${PV}"

DESCRIPTION="Phil Budne's port of Macro SNOBOL4 in C, for modern machines"
HOMEPAGE="http://www.snobol4.org/csnobol4/"
SRC_URI="mirror://snobol4/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	sys-devel/gcc
	sys-devel/m4
	sys-libs/gdbm[berkdb]
"
S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -e '/autoconf/s:autoconf:./autoconf:g' \
		-i configure || die 'autoconf sed failed'
	sed -e 's/$(INSTALL) -s/$(INSTALL)/' \
		-i Makefile2.m4 || die 'strip sed failed'
	echo "ADD_OPT([${CFLAGS}])" >>${S}/local-config
	echo "ADD_CPPFLAGS([-DUSE_STDARG_H])" >>${S}/local-config
	echo "ADD_CPPFLAGS([-DHAVE_STDARG_H])" >>${S}/local-config
}

src_configure() {
	./configure --prefix="${EPREFIX%/}/usr" \
		--snolibdir="${EPREFIX%/}/usr/lib/snobol4" \
		--mandir="${EPREFIX%/}/usr/share/man" \
		--add-cflags="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install

	rm "${ED%/}"/usr/lib/snobol4/{load.txt,README}

	dodoc doc/*txt

	use doc && dohtml doc/*html
}
