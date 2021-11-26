# If the file "BOOTSTRAPPED" is not already present then run bootstrapping tasks
if [ ! -f "/var/www/grav-admin/user/BOOTSTRAPPED" ]; then

  # Move the contents of the grav user directory into place
  mv /usr/local/bootstrap/user/* /var/www/grav-admin/user/

  # Recursively change ownership of grav user directory (ownership www-data:www-data)
  chown -R www-data:www-data /var/www/grav-admin/user

  # Add file BOOTSTRAPPED to indicate no further bootstrapping needed
  touch  /var/www/grav-admin/user/BOOTSTRAPPED

fi

# Remove the grav user directory in the bootstrapping directory
rm -R /usr/local/bootstrap/user

# Copy cronjob file from update directory to /etc/cron.d/
#cp -p /usr/local/bootstrap/grav_scheduler_cronjob /etc/cron.d/grav_scheduler_cronjob
  
# Restart cron service
#/etc/init.d/cron restart
