#!/usr/bin/env bash
set -e

echo '~~~ Configuring ImageMagick'

# Change the port and limit outside access
sudo sed -E -e 's|^( *)<policy +domain="resource" +name="width" +value="[^"]+"/>$|\1<policy domain="resource" name="width" value="32KP"/>|' \
         -E -e 's|^( *)<policy +domain="resource" +name="height" +value="[^"]+"/>$|\1<policy domain="resource" name="height" value="32KP"/>|' \
         -E -e 's|^( *)<policy +domain="resource" +name="memory" +value="[^"]+"/>$|\1<policy domain="resource" name="memory" value="8192MiB"/>|' \
         -E -e 's|^( *)<policy +domain="resource" +name="disk" +value="[^"]+"/>$|\1<policy domain="resource" name="disk" value="8192MiB"/>|' \
         -i=.bak /etc/ImageMagick-6/policy.xml

# Verify
if ! grep -q -E '^ *<policy +domain="resource" +name="width" +value="32KP"/>$' /etc/ImageMagick-6/policy.xml \
    || ! grep -q -E '^ *<policy +domain="resource" +name="height" +value="32KP"/>$' /etc/ImageMagick-6/policy.xml \
    || ! grep -q -E '^ *<policy +domain="resource" +name="memory" +value="8192MiB"/>$' /etc/ImageMagick-6/policy.xml \
    || ! grep -q -E '^ *<policy +domain="resource" +name="disk" +value="8192MiB"/>$' /etc/ImageMagick-6/policy.xml; then
    echo 'Failed to configure ImageMagick.'
    exit 1
fi

echo 'ImageMagick configured successfully.'
