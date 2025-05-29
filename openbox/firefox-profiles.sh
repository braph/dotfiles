#!/bin/bash

echo '<openbox_pipe_menu>'

while read -r; do
  if [[ "${REPLY:0:5}" = "Name=" ]] ; then
    ProfileName=${REPLY:5}
    ProfileNameSecure=${ProfileName/_/__}
    cat << EOF
<item label="Firefox $ProfileNameSecure" icon="/usr/share/icons/hicolor/16x16/apps/firefox.png">
  <action name="Execute">
    <execute> firefox -no-remote -P $ProfileName </execute>
  </action>
</item>
EOF
  fi
done < ~/.mozilla/firefox/profiles.ini

echo '</openbox_pipe_menu>'
