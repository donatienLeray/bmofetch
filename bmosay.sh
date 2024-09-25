#!/bin/bash
# This script replaces the text in the ASCII file and the configuration file,
# to make BMO say the specified string. https://github.com/Chick2D/neofetch-themes/blob/main/small/bmofetch/
# Made by https://github.com/donatienLeray

# Global variable for flags
VERBOSE=false
QUIET=false
RANDOM_MODE=false

# Get the path of the script
CONF_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Function to replace a specific line of a file wih a new string
replace_string_in_file() {
    local file_path="$1"
    local line_number="$2"
    local new_string="$3"

    # Check if the file exists
    if [ ! -f "$file_path" ]; then
        if [[ "$QUIET" = false ]]; then
            echo -e "\033[31mError: File '$file_path' not found.\033[39m" >&2
        fi
        exit 1
    fi

    # Check if the line number is valid
    total_lines=$(wc -l < "$file_path")
    if [ "$line_number" -gt "$total_lines" ] || [ "$line_number" -lt 1 ]; then
        if [[ "$QUIET" = false ]]; then
            echo -e "\033[31mError: Line number $line_number is out of range.\033[39m" >&2
        fi
        exit 1
    fi

    # Replace the specified line with the new string
    if ! sed -i "${line_number}s/.*/${new_string}/" "$file_path"; then
        if [[ "$QUIET" = false ]]; then
            echo -e "\033[31mError: Failed to replace line $line_number in file '$file_path'\033[39m\n with: $new_string" >&2
        fi
        exit 1
    fi

    # Debug message for verbose flag
    if [[ "$VERBOSE" = true ]]; then
        echo "replaced line $line_number in $file_path with '$new_string'"
    fi
}

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

# check if path is valid and diretory contains a bmofetch.conf and an bmo.txt file
check_path() {
    # Check if the directory exists
    if [ ! -d "$1" ]; then
        echo -e "\033[31mError: Directory '$1' not found.\033[39m" >&2
        exit 1
    fi
    # Check if the directory contains the required bmofetch.conf file
    if [ ! -f "$1/bmofetch.conf" ]; then
        echo -e "\033[31mError: File 'bmofetch.conf' not found in directory '$1'.\033[39m" >&2
        exit 1
    fi
    # Check if the directory contains the required bmo.txt file
    if [ ! -f "$1/bmo.txt" ]; then
        echo -e "\033[31mError: File 'bmo.txt' not found in directory '$1'.\033[39m" >&2
        exit 1
    fi
    # Set the script path to the provided path
    CONF_PATH="$1"
}


# Function to print the help message
print_help() {
    echo -e "
    \u001b[1mSYNOPSIS:
      sh $0 [options] <argument>\u001b[0m
    
    \u001b[1mDESCRIPTION:\u001b[0m
      This script enables you to change the text BMO says when using neofetch with the bmofetch.conf file.
      You can specify a new string for BMO to say, or get a random line from a file.
      you can find the complete neofetch-themes repository at https://github.com/donatienLeray
    
    \u001b[1mOPTIONS:\u001b[0m
      -v, --verbose       Enable verbose mode.(prints debug messages)
      -q, --quiet         Suppress output.
      -r, --random        Specify a file to get a random line from.
      -p, --path          Specify the path to the bmofetch directory.
      -h, --help          Display this help message and exit.
      -vq, -qv            Enable both verbose and quiet mode.(only prints debug messages)
      -**,-***            Any combination of r, v, q can be used instead  of the above
    
    \u001b[1mEXAMPLES:\u001b[0m
      sh $0 \"Hello, world!\"
      sh $0 -vq --random file.txt
      sh $0 -qr file.txt
      sh $0 --help
      sh $0 -v -p /path/to/bmofetch \"Hello, world!\"
    "
    exit 0
}


# Check if the correct number of arguments is provided
if [[ "$#" -lt 1 ]] || [[ "$#" -gt 4 ]]; then
    printf "Usage: sh %s [-v|--verbose] [-q|--quiet]  [-r|--random <file>] <new_string> [-h| --help] [-p|--path] \n" "$0" >&2
    exit 0
fi

# Parse arguments
# getops couldn't be used here bc. it doesn't support long options
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -v|--verbose) VERBOSE=true ;;
        -q|--quiet) QUIET=true ;;
        -r|--random) RANDOM_MODE=true;;
        -p|--path) shift ; check_path "$1" ;;
        -h|--help) print_help ;;
        -vq|-qv) VERBOSE=true; QUIET=true ;;
        -rv|-vr) RANDOM_MODE=true; VERBOSE=true ;;
        -rq|-qr) RANDOM_MODE=true; QUIET=true ;;
        -rvq|-rqv|-vqr|-vrq|-qrv|-qvr) RANDOM_MODE=true; VERBOSE=true; QUIET=true ;;
        *)  break ;;
    esac
    shift
done

# If the random_mode flag is set
if [[ "$RANDOM_MODE" = true ]]; then
    # Check if the file exists
    if [ ! -f "$1" ]; then
        if [[ "$QUIET" = false ]]; then
            echo -e "\033[31mError: File '$1' not found.\033[39m" >&2
        fi
        exit 1
    fi
    # Get a random line from the file as the input
    read_input=$(shuf -n 1 $1)
else
    read_input="$1"
fi 

# Check that input contains NO carriage returns
if [[ $read_input == *'\r'* ]]; then
    if [[ "$QUIET" = false ]]; then
        echo -e "\033[31mError: The input string can not contain any carriage returns.\033[39m" >&2
    fi
    exit 1
fi

# read input line by line and save in lines array
IFS='\n' read -r -d '' -a lines <<< "$read_input"

input=()
# itterate over the lines and clean them up
for line in "${lines[@]}"; do
    #if the line is empty ignore it
    if [ -n "$line" ]; then
        # clean up multiple and leading or trailing spaces
        input+=("$(echo "$line" | tr -s ' '| sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')")
    fi
done

#find the longest line in input
longest=0
for line in "${input[@]}"; do
    if [ ${#line} -gt $longest ]; then
        longest=${#line}
    fi
done

# Get the inner size of the speach bubble is longest +2
bub_len=$((longest + 2))

# Make the top line "ˏ______ˎ"
top_line="ˏ$(printf '_%.0s' $(seq 1 $bub_len))ˎ"

# Make the bottom line "`ˉˉˉˉˉˉ´"
bottom_line="\`$(printf 'ˉ%.0s' $(seq 1 $bub_len))\´"

# # The Speach bubble has to be cut in two parts: 
# # The first part will be in the ASCII file and the second part will be in the config file
# # Default case for start part of the speach bubble 
# start_top_line="$top_line"
# start_bottom_line="$bottom_line"
# # Deafault case for end part of the speach bubble
# end_top_line=""
# end_bottom_line=""

# # If input string was not empty
# if [ "$bub_len" -gt 2 ]; then
#     # Get the 4 first chars of the lines
#     start_top_line=${top_line:0:4}
#     start_bottom_line=${bottom_line:0:4}
#     # Get rest chars of the lines
#     end_top_line=${top_line: 4}
#     end_bottom_line=${bottom_line: 4}
# fi

# add top line ad start of the input array and bottom line at the end of the array
input=("$top_line" "${input[@]}" "$bottom_line")

echo "----test new input array----"
for line in "${input[@]}"; do
    echo "$line"
done
echo "----test new input array----"

center_ascii=()
center_conf=()
for line in "${input[@]}"; do
    echo "line: $line"
    
    # if line is neither first nor last line
    if [ "$line" != "${input[0]}" ] && [ "$line" != "${input[-1]}" ]; then
        # Get the length of the line
        line_len=${#line}
        echo "make new line"
        # Calculate the number of spaces to add to the line
        spaces=$((longest - line_len))
        # Add the spaces to the line ans | at the beginning and end
        input_line=$(printf "\| %s%*s \|" "$line" $spaces)
    else 
        input_line="$line"   
    fi
    # write line back to the array
    center_ascii+=("$input_line")
    if [ "${#input_line}" -gt 4 ]; then
        # Add the forth char of the line to the center_conf array
        center_conf+=("${input_line:5:1}")
    else
        # Add a space to the center_conf array
        center_conf+=("")
    fi
done

echo "----test center arrays----"
for line in "${center_ascii[@]}"; do
    echo "$line"
done
echo "----test center arrays----"

echo "----test center conf array----"
for line in "${center_conf[@]}"; do
    echo "$line"
done
echo "----test center conf array----"
exit 1

# Path to the ASCII file and the configuration file
ascii_file="$CONF_PATH/bmo.txt"
conf_file="$CONF_PATH/bmofetch.conf"

# Make the first part of the speak bubble in the ascii file (2 chars of the text)
replace_string_in_file "$ascii_file" "1" "\\\u001b[1m                  $start_top_line"
replace_string_in_file "$ascii_file" "2" "\\\033[36m     ˏ________ˎ   \\\033[39m$start_center_text"
replace_string_in_file "$ascii_file" "3" "\\\033[36m    \\/|\\\033[39m ______\\\033[36m | \\\033[39m \\/$start_bottom_line"

# Make the end part of the speak bubble in the conf file (form the third text char to the end)
replace_string_in_file "$conf_file" "5" "    prin \"$end_top_line\""
replace_string_in_file "$conf_file" "6" "    prin \"$end_center_line\"" 
replace_string_in_file "$conf_file" "7" "    prin \"$end_bottom_line\""


# Search for the line starting with "image_source" in conf file
line_number=$(grep -n "^image_source" "$conf_file" | cut -d: -f1)

# Check if a line was found
if [[ -n "$line_number" ]]; then
    # replace everey / with \\/ to escape the slashes
    ascii_file=$(echo "$ascii_file" | sed 's/\//\\\//g')
    # replace the image source in the conf file with actual path to the ascii file
    replace_string_in_file "$conf_file" "$line_number" "image_source=$ascii_file"
else
    # Error messsage if no line was found
    echo -e "\033[31mError: No line starting with 'image_source' found in $conf_file\033[39m" >&2
    exit 1
fi

# Success message (if not quiet)
if [[ "$QUIET" = false ]]; then
    echo -e "\033[32mSuccess: BMO now says \"$input\"\033[39m"
fi

exit 0