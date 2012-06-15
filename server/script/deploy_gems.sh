#!/bin/sh
exec bundle install --deployment --without "development_setup development_require test_setup test_require"
