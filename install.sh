#!/usr/bin/env bash


echo '
+------------------------------------+
        Init dev-environment
+------------------------------------+
'

# remove sudo timeout
sudo perl -i -pe "s/^Defaults\tenv_reset.*/Defaults\tenv_reset, timestamp_timeout=-1/" /etc/sudoers

sudo -i sudo -u $USER -i "`pwd`/init.sh"

# set sudo timeout back to 60s
sudo perl -i -pe "s/^Defaults\tenv_reset.*/Defaults\tenv_reset, timestamp_timeout=60/" /etc/sudoers