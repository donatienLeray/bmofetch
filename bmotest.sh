#!/bin/bash

add_line_after_specific_line() {
    local file="$1"
    local line_number="$2"
    local -n new_lines=$3
    local temp_file=$(mktemp)

    # Ensure the line number is valid
    if [[ ! "$line_number" =~ ^[0-9]+$ ]] || (( line_number < 1 )); then
        printf "Invalid line number: %d\n" "$line_number" >&2
        return 1
    fi

    local current_line=1
    while IFS= read -r line || [[ -n "$line" ]]; do
        printf "%s\n" "$line" >> "$temp_file"
        if (( current_line == line_number )); then
            for new_line in "${new_lines[@]}"; do
                printf "%s\n" "$new_line" >> "$temp_file"
            done
        fi
        ((current_line++))
    done < "$file"

    # Handle case where line_number is greater than the number of lines in the file
    if (( current_line <= line_number )); then
        printf "%s\n" "$new_line" >> "$temp_file"
    fi

    mv "$temp_file" "$file"
}


main() {
    lines=("d" "e" "f")
    # Get the path of the script
    SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    # Path to the ASCII file and the configuration file
    file="$SCRIPTPATH/bmofile.txt"
    # print file
    cat "$file"
    echo -e "\n"
    for line in "${lines[@]}"; do
        echo "line: $line"
    done
    add_line_after_specific_line "$file" 1 lines

    # Display the modified file
    printf "Modified %s:\n" "$file"
    cat "$file"
}

main
