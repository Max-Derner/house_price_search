#! /bin/bash

# source common variables
. ./common_variables.sh

# source common funtions
. ./common_functions.sh

download_data() {
    CHOICES=$(awk -F ',' '{print $1}' < "$ENDPOINTS_FILE")
    CHOICES+=' Exit'
    QUEUE="Select the dataset you would like to download."
    echo "${QUEUE}"
    select CHOICE in $CHOICES; do
        if [ "${CHOICE}" = 'Exit' ]; then return 0; fi ### ! Exit case ###
        if [ -n "${CHOICE}" ]; then
            CSV_LINE=$(grep -F "${CHOICE}" < "$ENDPOINTS_FILE")
            END_POINT=$(echo "${CSV_LINE}" | awk -F ',' '{print $2}')
            CURRENT_MONTH=$(date '+%Y-%m')
            FILE_NAME=$(echo "${CSV_LINE}" | awk -F ',' '{print $3}' | sed -e "s/<MONTH>/${CURRENT_MONTH}/")
            FILE_PATH="${DATA_SET_DIR}${FILE_NAME}"
            echo "downloading..."
            eval "curl -L ${END_POINT}" | sed -e 's/",/,/g' -e 's/,"/,/g' -e 's/^"//g' -e 's/"$//g' > "${FILE_PATH}" && echo "file now at ${FILE_PATH}"
        fi
        # clear reply and choice, else behaviour unpredictable
        REPLY=""
        CHOICE=""
        echo "${QUEUE}"
    done
}

DATA_SETS=$(get_data_sets)

if [ -z "${DATA_SETS}" ]; then
    echo "It appears as though you do not have any data sets downloaded."
else
    echo "These are your listed data sets:"
    echo -e "${DATA_SETS}\n"
fi


echo "Would you like to download datasets? (y/n)"
# restrict input
while ! valid_y_n_input "${CHOICE}"; do
    read -n 1 -s CHOICE
done
case "${CHOICE}" in
    [yY])
        echo "Downloading the same dataset will overwrite it..."
        download_data
        echo "Continuing."
        ;;
    [nN])
        if [ -z "${DATA_SETS}" ]; then
            echo "We cannot search datasets if we have none."
            echo "Exiting..."
            exit 0 ### ! Exit case ###
        else
            echo "Ok, continuing."
            return 0 ### ! Exit case ###
        fi
        ;;
esac

