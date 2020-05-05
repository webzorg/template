for filename in /var/www/leftovers/current/lib/systemd/*.service; do
  systemctl --user start ${filename##*/}
done