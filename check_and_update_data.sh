#! /bin/bash

# source common variables
. ./common_variables.sh

# give space between output
echo -e "\n"

valid_y_n_input() {
    # simple pattern match
    case $1 in
        [yYnN])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

download_data() {
    echo "Let's do this thing!"
}


# fetch data sets from directory and supress failures
DATA_SETS=$(ls ./"${DATA_SET_DIR}"*.csv 2>/dev/null)

if [ -z "${DATA_SETS}" ]; then
    echo "It appears as though you do not have any data sets downloaded."
else
    echo "These are your listed data sets:"
    echo -e "${DATA_SETS}\n"
fi

if true; then
    echo "Would you like to download or update datasets? (y/n)"
    # restrict input
    while ! valid_y_n_input "${CHOICE}"; do
        read -n 1 -s CHOICE
    done
    case "${CHOICE}" in
        [yY])
            download_data
            ;;
        [nN])
            if [ -z "${DATA_SETS}" ]; then
                echo "We cannot search datasets if we have none."
                echo "Exiting..."
                exit 0
            else
                echo "ok"
                return 0
            fi
            ;;
        *)
            echo "Something has gone very wrong"
            echo "Exiting..."
            exit 1
            ;;
    esac
fi
