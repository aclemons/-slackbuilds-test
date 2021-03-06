config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

config etc/httpd/extra/icingaweb2.conf.new

[ ! -f etc/icingaweb2/setup.token ] \
  && icingacli setup token create \
  && chown apache:apache etc/icingaweb2/setup.token

find etc/icingaweb2 -type f -name '*.new' \
  | while read new ; do config $new ; done
