#  Copyright 2014, 2015, 2016 by Cumulus Networks, Inc.
#  Dave Olson <olson@cumulusnetworks.com>

EXTRA_DIST = ChangeLog README audisp_tacplus.spec \
	audisp-tac_plus.conf audisp-tacplus.conf

audisp_tacplus_SOURCES = audisp-tacplus.c
audisp_tacplus_CFLAGS = -O
audisp_tacplus_LDADD = -lauparse -ltacplus_map
sbin_PROGRAMS = audisp-tacplus
man_MANS = audisp-tacplus.8

clean-generic:
	rm -rf autom4te*.cache 
	rm -f *.rej *.orig *.lang

ACLOCAL_AMFLAGS = -I config

MAINTAINERCLEANFILES = Makefile.in config.h.in configure aclocal.m4 \
                       config/config.guess  config/config.sub  config/depcomp \
                       config/install-sh config/ltmain.sh config/missing

# augenrules will build a new audit.rules including audisp-tacplus.rules
# so install it the debian jessie way in /etc/audit/rules.d
install-data-hook:
	${INSTALL} -d $(DESTDIR)$(sbindir)/
	${INSTALL} -m 755 audisp-tacplus $(DESTDIR)$(sbindir)
	${INSTALL} -d $(DESTDIR)$(sysconfdir)/audisp/plugins.d
	${INSTALL} -d $(DESTDIR)$(sysconfdir)/audit/rules.d
	${INSTALL} -m 600 audisp-tac_plus.conf $(DESTDIR)$(sysconfdir)/audisp/
	${INSTALL} -m 644 audisp-tacplus.conf $(DESTDIR)$(sysconfdir)/audisp/plugins.d
	${INSTALL} -m 644 -o 0 audisp-tacplus.rules $(DESTDIR)$(sysconfdir)/audit/rules.d

