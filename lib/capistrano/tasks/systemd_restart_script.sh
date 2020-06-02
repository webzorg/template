for filename in /var/www/dummy_app/current/lib/systemd/*.service; do
  systemctl --user restart ${filename##*/}
done