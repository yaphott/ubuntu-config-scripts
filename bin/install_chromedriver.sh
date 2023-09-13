#!/usr/bin/env bash -e

# NOTE: THIS IS INCOMPLETE

# First, find out which version of Chrome you are using.
# Let's say you have Chrome 72.0.3626.81.
google_chrome_version=$( google-chrome --version | sed "s|^Google Chrome ||" )
if [[ $google_chrome_version ]]; then
    echo '+++ Detected Google Chrome '"$google_chrome_version"
else
    echo 'Failed to detect Google Chrome version.'
    exit 1
fi

# Take the Chrome version number, remove the last part, and append the result to URL "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_".
# For example, with Chrome version 72.0.3626.81, you'd get a URL "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_72.0.3626".
chrome_driver_version=$( echo "$google_chrome_version" | sed -E "s|([0-9](\.[0-9]+)+)\.[0-9]+|\1|" )
url_to_fetch='https://chromedriver.storage.googleapis.com/LATEST_RELEASE_'"$chrome_driver_version"
echo 'Fetching '"$url_to_fetch"
latest_release_dev=$( curl $url_to_fetch )

# Use the URL created in the last step to retrieve a small file containing the version of ChromeDriver to use.
# For example, the above URL will get your a file containing "72.0.3626.69".
# (The actual number # may change in the future, of course.)
# 
# Use the version number retrieved from the previous step to construct the URL to download ChromeDriver.
# With version 72.0.3626.69, the URL # would be "https://chromedriver.storage.googleapis.com/index.html?# path=72.0.3626.69/".
# 
latest_release_base=$( echo "$latest_release_dev" | sed -E "s|([0-9](\.[0-9]+)+)\.[0-9]+|\1|" )
url_to_fetch='https://chromedriver.storage.googleapis.com/LATEST_RELEASE_'"$latest_release_base"
echo 'Fetching '"$url_to_fetch"
latest_release_stable=$( curl $url_to_fetch )

echo 'Release Information'
echo '    Base: '"$latest_release_base"
echo '  Stable: '"$latest_release_stable"
echo '     Dev: '"$latest_release_dev"

chromedriver_url='https://chromedriver.storage.googleapis.com/index.html?path='"$latest_release_stable"'/'
echo 'Downloading chromdriver from '"$chromedriver_url"

# After the initial download, it is recommended that you occasionally go through the above process again to see if there are any bug fix releases.
