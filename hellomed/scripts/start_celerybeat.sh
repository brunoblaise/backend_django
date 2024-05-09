#!/bin/bash

NAME="hellomed_api"
DJANGODIR=/home/hellomed/hellomed-api-v2
SOCKFILE=/home/hellomed/hellomed_api.sock
USER=root
GROUP=root
NUM_WORKERS=3
DJANGO_SETTINGS_MODULE=hellomed.settings
DJANGO_WSGI_MODULE=hellomed.wsgi

echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $DJANGODIR
source venv/bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE


# Export env.sh
. ./env.sh

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not$
# exec venv/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
#  --name $NAME \
#  --workers $NUM_WORKERS \
#  --user $USER \
#  --bind=unix:$SOCKFILE


# exec venv/bin/gunicorn --bind=unix:$SOCKFILE  ${DJANGO_WSGI_MODULE}:application

exec celery -A celeryconfig beat -l info --scheduler django_celery_beat.schedulers:DatabaseScheduler
