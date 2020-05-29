for filename in /var/www/leftovers/current/lib/systemd/*.service; do
  systemctl --user stop ${filename##*/}
done