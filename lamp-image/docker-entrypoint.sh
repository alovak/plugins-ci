#!/bin/bash
set -e
tar cf - --one-file-system -C /usr/src/wordpress . | tar xf -
echo >&2 "Complete! WordPress has been successfully copied to $(pwd)"
if [ ! -e .htaccess ]; then
	# NOTE: The "Indexes" option is disabled in the php:apache base image
	cat > .htaccess <<-'EOF'
		# BEGIN WordPress
		<IfModule mod_rewrite.c>
		RewriteEngine On
		RewriteBase /
		RewriteRule ^index\.php$ - [L]
		RewriteCond %{REQUEST_FILENAME} !-f
		RewriteCond %{REQUEST_FILENAME} !-d
		RewriteRule . /index.php [L]
		</IfModule>
		# END WordPress
	EOF
	chown www-data:www-data .htaccess
fi

exec "$@"
