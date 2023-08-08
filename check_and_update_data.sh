#! /bin/bash

# source common variables
. ./common_variables.sh

# source common funtions
. ./common_functions.sh

download_update_data() {
    CHOICES=$(awk -F ',' '{print $1}' < "$ENDPOINTS_FILE")
    echo "Select the dataset you would like to download, or type f when finished"
    select CHOICE in $CHOICES; do
        if [ "${REPLY}" = 'f' ]; then return 0; fi
        if [ -n "${CHOICE}" ]; then
            CSV_LINE=$(grep -F "${CHOICE}" < "$ENDPOINTS_FILE")
            END_POINT=$(echo "${CSV_LINE}" | awk -F ',' '{print $2}')
            CURRENT_MONTH=$(date '+%Y-%m')
            FILE_NAME=$(echo "${CSV_LINE}" | awk -F ',' '{print $3}' | sed -e "s/<MONTH>/${CURRENT_MONTH}/")
            FILE_PATH="${DATA_SET_DIR}${FILE_NAME}"
            echo "downloading..."
            eval "curl -L ${END_POINT} > ${FILE_PATH}" && echo "file now at ${FILE_PATH}"
        fi
        # clear reply and choice, else behaviour unpredictable
        REPLY=""
        CHOICE=""
    done
}

DATA_SETS=$(get_data_sets)

if [ -z "${DATA_SETS}" ]; then
    echo "It appears as though you do not have any data sets downloaded."
else
    echo "These are your listed data sets:"
    echo -e "${DATA_SETS}\n"
fi


echo "Would you like to download or update datasets? (y/n)"
# restrict input
while ! valid_y_n_input "${CHOICE}"; do
    read -n 1 -s CHOICE
done
case "${CHOICE}" in
    [yY])
        download_update_data
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

