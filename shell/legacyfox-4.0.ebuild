# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Firefox shim to add support for legacy extentions"
HOMEPAGE=""
SRC_URI="https://git.gir.st/LegacyFox.git/snapshot/v${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
#S="${WORKDIR}"/*

src_unpack() {
	if [[ -n ${A} ]]; then
		#mv $A $PF
		unpack ${A}
		mv * $PF
	fi
}


#src_prepare(){
#	mv Leg* legacyfox-${PV}
#}

src_install() {
	#/usr/lib64/firefox
	#echo ${D}
	DESTDIR_FIREFOX="${D}/lib64/firefox"
	#mkdir -p "$DESTDIR_FIREFOX"
	mkdir "${D}/lib64"
	mkdir "${D}/lib64/firefox"
	make DESTDIR="$DESTDIR_FIREFOX" install || die "make install failed"
	#DESTDIR="/usr/lib64/firefox/"
	#cp config.js "$DESTDIR"
	#make DISDIR=${D} install || die "make install failed"
}


