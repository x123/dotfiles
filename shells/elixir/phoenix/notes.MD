mix local.hex
mix archive.install phx_new
mix phx.new someapp

initdb --no-locale --encoding=UTF-8

# make directory for postgres socket somewhere
mkdir db/socket

# edit postgres.conf and set socket dir
unix_socket_directories = '/tmp/postgresql'

# start the server
pg_ctl -l "$PGDATA/server.log" start

# creat pg user

createuser -h /tmp/postgresql/ postgres --createdb
mix ecto.create
mix phx.server

pg_ctl stop
