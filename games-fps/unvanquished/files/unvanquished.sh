#!/bin/sh
cd "@GAMES_LIBDIR@/unvanquished"
exec "@GAMES_BINDIR@"/unvanquishedclient \
	+set fs_libpath "@GAMES_LIBDIR@/unvanquished" \
	+set fs_basepath "@GAMES_DATADIR@/unvanquished" \
	"$@"

