# If the file "BOOTSRTAPPED" is not already present then run bootstrapping tasks
if [ ! -f "/var/www/grav/user/BOOTSTRAPPED" ]; then

  # Move the contents of the grav user directory into place
  mv /usr/local/bootstrap/user/* /var/www/grav-admin/user/

  # Recursively change ownership of grav user directory (ownership www-data:www-data)
  chown -R www-data:www-data /var/www/grav-admin/user

  # Add file BOOTSTRAPPED to indicate no further bootstrapping needed
  touch  /var/www/grav/user/BOOTSTRAPPED

fi

# Remove the grav user directory in the bootstrapping directory
rm -R /usr/local/bootstrap/user
