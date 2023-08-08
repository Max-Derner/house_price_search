#! /bin/bash

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

get_data_sets() {
    # fetch data sets from directory and supress failures
    DATA_SETS=$(ls ./"${DATA_SET_DIR}"*.csv 2>/dev/null)
    echo "${DATA_SETS}"
}