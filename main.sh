#! /bin/bash

# open up splash page
. ./splash_page.sh

# loop
OPTIONS="Download-Or-Check-Datasets
Exit"
while true; do
    echo -e "\n\nWhat would you like to do?"
    select OPTION in $OPTIONS; do
        case "${OPTION}" in
            "Download-Or-Check-Datasets")
                # allow user to download or updaet datasets
                . ./check_and_update_data.sh
                break
                ;;
            "Exit")
                break 2
                ;;
        esac
    done
done

exit 0
