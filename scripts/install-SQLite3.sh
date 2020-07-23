#!/usr/bin/env bash

sudo apt-get --assume-yes --no-install-recommends install sqlite3=3.32.3-1
sqlite3 -version
ln -s /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 libsqlite3.so
