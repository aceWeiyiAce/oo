#!/bin/sh -vx
bundle_identifier="$(/usr/libexec/PlistBuddy -c "print :CFBundleIdentifier" ../../*/LingZhi-Info.plist)"
xml_filepath=./../../../builds/$BUILD_NUMBER/changelog.xml
echo xml_filepath:$xml_filepath "\n"
echo bundle_identifier:$bundle_identifier "\n"
#ls ./../../../builds/$BUILD_NUMBER/
curl -k -F "mark=${bundle_identifier}" -F "xml=@${xml_filepath}" -F "m=client" -F "c=api" -F "a=file_xml" https://172.16.10.198/iss_apps/public_admin/index.php > /Library/WebServer/Documents/installer/log/buildchangelog.log