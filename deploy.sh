# Move the build/web output to Nginx’s web root
rm -rf /var/www/flutter_web
mkdir -p /var/www/flutter_web
cp -r build/web/* /var/www/flutter_web/
