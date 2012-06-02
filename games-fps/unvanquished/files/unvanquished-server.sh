#!/bin/sh
cd "@GAMES_STATEDIR@/unvanquished-server"

[ -f @UNV_SERVER_DATA@/server.cfg ] \
	|| ln -sf @GAMES_SYSCONFDIR@/unvanquished/server.cfg \
	@UNV_SERVER_DATA@/server.cfg
[ -f @UNV_SERVER_DATA@/maprotation.cfg ] \
	|| ln -sf @GAMES_SYSCONFDIR@/unvanquished/maprotation.cfg \
	@UNV_SERVER_DATA@/maprotation.cfg

exec "@GAMES_BINDIR@"/unvanquishedded \
	+set fs_libpath "@GAMES_LIBDIR@/unvanquished" \
	+set fs_basepath "@GAMES_DATADIR@/unvanquished" \
	+exec server.cfg \
	"$@"

