#!/bin/sh
# 
# The contents of this file are licenced. You may obtain a copy of 
# the license at https://github.com/thsmi/rpiwebcam/ or request it via 
# email from the author.
#
# Do not remove or change this comment.
# 
# The initial author of the code is:
#   Thomas Schmid <schmid-thomas@gmx.net>
#      

#
# General setting,
#

# Directory where to save screenshots on a disk. Use full if you want to do timeshift records.
archive_dir=/home/webcam/archive
# The filename it should contain a date, it's also quite usefull to add epoch time.
capture_file=$(date +%F)_$(date +%_H)-$(date +%M)-$(date +%S)_$(date +%s).jpg
# Filename which is used for the uploaded image
upload_file=webcam.jpg 

#
# FTP Settings.
#

# ftp server's address, can be a domain or an ip addess
ftp_server=ftp.example.org
# ftp username
ftp_user=yourusername
# password for the ftp username above
ftp_pwd=yourpassword
# the path on the server where the image should be uploaded
ftp_path=/


#
# fswebcam takes screenshots from various video devices. 
# Check the fswebcam man pages for more details on fswebcam.
#
fswebcam -p YUYV -F 25 -D 5 -r "352x288" \
  --info "Neubau" \
  $archive_dir/$capture_file \
  \
  --no-banner \
  $archive_dir/raw/$capture_file 

  #
  # Uploads pictures via lftp.
  # lftp is a powerfull ftp tool. It's aware of ftp proxies and authentication.
  #
lftp <<EOF
    set cmd:fail-exit 1
    open '$ftp_server'
    user '$ftp_user' '$ftp_pwd'
    cd '$path'
    put '$archive_dir/$capture_file' -o '$upload_file.jpg'
    bye
EOF
