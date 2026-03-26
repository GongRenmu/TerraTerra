#!/usr/bin/env sh
set -e

flask --app run.py db upgrade
exec gunicorn run:app --bind 0.0.0.0:${PORT:-10000}