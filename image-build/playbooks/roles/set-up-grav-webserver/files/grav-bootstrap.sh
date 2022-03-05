# SPDX-FileCopyrightText: 2022 Wilfred Nicoll <xyzroller@rollyourown.xyz>
# SPDX-License-Identifier: GPL-3.0-or-later

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
