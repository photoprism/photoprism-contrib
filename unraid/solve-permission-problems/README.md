# Resolve "Permission Denied" On Unraid

## Introduction


After some updates, or after having migrated Photoprism's Appdata folder, you can meet some troubles manifested by this error message : "Permission Denied".

To solve this matter the resolution is quite easy.

## Resolution    

First, we need to add a variable to our Photoprism container:
PHOTOPRISM_DISABLE_CHOWN
Set the value of this variable to false.

Then, we must change (temporarily) the UID and GID value of our container. To procceed, scroll down and click onto "Show more settings" in our container edit page
and copy the assigned value to UID and GID variable. Then set both of them to 0, which relates to the root user.

You can now apply the modification to our container. You'll notice in the logs that the message "PHOTOPRISM_DISABLE_CHOWN="true" disables permission updates"
doesn't show up. The folder permissions have been rectified.

Once our Photoprism container has fully boot up, you can set back the UID and GID variable to their original value. The PHOTOPRISM_DISABLE_CHOWN is only available
with root user, so it won't run. Running Photoprism with root user is, as far as I know, only necessary to run this script.
