#!/bin/bash
set -e

# Fix permissions for directories that must be writable by RapidLeech
# This runs on every container start to handle external volume mounts
chmod -R 777 /var/www/html/files || echo "Warning: Could not chmod /var/www/html/files"
chmod -R 777 /var/www/html/configs || echo "Warning: Could not chmod /var/www/html/configs"

# Execute the default php apache entrypoint
exec docker-php-entrypoint "$@"
