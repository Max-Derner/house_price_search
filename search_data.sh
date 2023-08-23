#! /bin/bash

# source common variables
. ./common_variables.sh

# source common funtions
. ./common_functions.sh

DATA_SETS=$(get_data_sets)
PRETTY_PRINT_FORMAT='{printf "Price: £" $2 '%-60s' "Address: " $9 ", " $8 ", " $10 ", " $11 ", " $12 ", " $13 ", " $14 ", " $4 "\n"}'

if [ -z "${DATA_SETS}" ]; then
    echo "It appears as though you do not have any datasets downloaded."
    echo "You must have a dataset to search."
    return 1  ## ! exit case ##
else
    echo "These are your listed data sets:"
    echo -e "${DATA_SETS}\n"
fi

echo "Which data set would you like to work with?"
select DATA_SET in $DATA_SETS; do
    if [ -n "${DATA_SET}" ]; then break; fi
done

echo "You have chosen ${DATA_SET}"

search_by_postcode() {
    DATA_SET="${1}"
    
}

search_field_equality() {
    DATA_SET="${1}"
    FIELD="${2}"
    VALUE="${3}"
    awk -F ',' "${VALUE} = \$${FIELD} {print \$0}" <"${DATA_SET}"
}

search_field_greater_than() {
    DATA_SET="${1}"
    FIELD="${2}"
    VALUE="${3}"
    awk -F ',' "${VALUE} > \$${FIELD} {print \$0}" <"${DATA_SET}"
}

search_field_less_than() {
    DATA_SET="${1}"
    FIELD="${2}"
    VALUE="${3}"
    awk -F ',' "${VALUE} < \$${FIELD} {print \$0}" <"${DATA_SET}"
}

pretty_print() {
    data_to_print="${1}"
    # awk -F ',' '{print "Price: £", $2, "Address: ", $8, ",", $9, ",", $10, ",", $11, $12, $13, $14, $4}'
    awk -F ',' 'BEGIN {print "Type is as follows -> D: Detached, S: Semi-Detached, T: Terraced, F: Flats/Maisonettes, O: Other"} {printf "Date sold: %-15s Price: £%-15s Type: %-5s Address: %s, %s, %s, %s, %s, %s, %s, %s\n", $3, $2, $5, $9, $8, $10, $11, $12, $13, $14, $4}' <"${data_to_print}"
}

# search_field_equality "${DATA_SET}" 8 1
# DATA=$(search_field_equality "${DATA_SET}" 8 1)
pretty_print "$DATA_SET"