#!/bin/bash
target="$1"
rm "$HOME/x.x/$target.nginx"
sudo port reload nginx

# function is_numer {
#     echo "$1" | awk '{if ($1+0 == $1) print "true"; else print "false"}'
# }

# if [ $(is_number "$target") == "true" ]; then

# fi
