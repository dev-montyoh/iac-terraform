#!/bin/bash

# install mutt (Alpine Linux)
sudo apt-get update
sudo apt-get install -y mutt

# Gmail account info
GMAIL_USERNAME=$1
GMAIL_PASSWORD=$2

# mutt configuration path
MUTT_CONFIG_FILE="$HOME/.muttrc"

# mutt configuration
cat > "$MUTT_CONFIG_FILE" <<EOF
set ssl_starttls=yes
set ssl_force_tls=yes
set from = $GMAIL_USERNAME
set realname = $GMAIL_USERNAME

# IMAP settings
set imap_user = $GMAIL_USERNAME
set imap_pass = $GMAIL_PASSWORD

# SMTP settings
set smtp_url = "smtps://$GMAIL_USERNAME@smtp.gmail.com:465/"
set smtp_pass = $GMAIL_PASSWORD

# Folder settings
set folder = "imaps://imap.gmail.com/"
set spoolfile = "+INBOX"
set postponed = "+[Gmail]/Drafts"
set record = "+[Gmail]/Sent Mail"
EOF