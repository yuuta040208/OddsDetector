#!/bin/sh

eval heroku pg:backups:capture --app odds-detector
curl `heroku pg:backups public-url --app odds-detector` > production_db.dump
eval pg_restore --verbose --clean --no-acl --no-owner -U postgres -h localhost -p 54320 -d odds_detector_development production_db.dump

