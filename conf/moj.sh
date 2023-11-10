#!/bin/bash

sudo chmod 777 -R /tmp/

sudo chmod 777 -R /mnt/problems/
cd /home/bd/site
. ../venv/bin/activate
./make_style.sh
python3 manage.py collectstatic
python3 manage.py compilemessages
python3 manage.py compilejsi18n
