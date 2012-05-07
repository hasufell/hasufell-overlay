#!/bin/sh
cd "@GAMES_STATEDIR@/unvanquished-server"

exec "@GAMES_BINDIR@"/unvanquishedded \
	+set fs_libpath "@GAMES_LIBDIR@/unvanquished" \
	+set fs_basepath "@GAMES_STATEDIR@/unvanquished" \
	+exec server.cfg \
	"$@"

