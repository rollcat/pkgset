PREFIX=/usr/local

install:
	install -o root -g wheel -m 555 pkgset.pl ${PREFIX}/sbin/pkgset
	install -o root -g wheel -m 444 pkgset.1 ${PREFIX}/man/man1/pkgset.1
