#!/bin/bash
# This script replaces the text in the ASCII file and the configuration file,
# to make BMO say the specified string. https://github.com/Chick2D/neofetch-themes/blob/main/small/bmofetch/
# Made by https://github.com/donatienLeray

# Global variable for flags
VERBOSE=false
QUIET=false
RANDOM_MODE=false
# Global variable for the gap size between the text and the ASCII 
GAP_SIZE=-44
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

# check if path is valid and diretory contains a bmofetch.conf and an bmo.txt file
check_path() {
    # Check if the directory exists
    if [ ! -d "$1" ]; then
        if [[ "$QUIET" = false ]]; then
            echo -e "\033[31mError: Directory '$1' not found.\033[39m" >&2
        fi
        exit 1
    fi
    # Check for file bmofetch.conf and bmo.txt
    check_file "$1" "bmofetch.conf"
    check_file "$1" "bmo.txt"
    # Set the script path to the provided path
    CONF_PATH="$1"
}

# check if a file exists under the provided path
check_file() {
    # Check if the directory contains the required file
    if [ ! -f "$1/$2" ]; then
        # if quiet mode exit since it user cant be asked to copy the file
        if [[ "$QUIET" = true ]]; then
            exit 1
        fi
        # Check if the CONF_PATH contains the required file
        if [ ! -f "$CONF_PATH/$2" ]; then
            echo -e "\033[31mError: File '$2' not found in directory '$1' neither in directory '$CONF_PATH'.\033[39m" >&2
            exit 1
        fi
        # Ask the user if it should be copied to the provided path
        read -p "File '$2' not found in directory '$1'. Do you want to copy it from '$CONF_PATH'? [Y/n]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]]; then
            # copy file so that it can be modified
            cp --no-preserve=mode,ownership "$CONF_PATH/$2" "$1"
            # Check if the file was copied successfully
            if [ ! -f "$1/$2" ]; then
                echo -e "\033[31mError: Failed to copy '$2' to directory '$1'.\033[39m" >&2
                exit 1
            # check if the file is readable and writable
            elif [ ! -r "$1/$2" ] || [ ! -w "$1/$2" ]; then
                echo -e "\033[31mError: File '$1/$2' is not readable or writable.\033[39m" >&2
                exit 1
            fi
            # copy successful
            echo -e "\033[32mSuccess: File '$2' copied to directory '$1'.\033[39m\n"
        else
            # exit if the user does not want to copy the file
            echo -e "\033[31mError: File '$2' not found in directory '$1'.\033[39m" >&2
            exit 1
        fi
    fi
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
if [[ "$#" -lt 1 ]] || [[ "$#" -gt 6 ]]; then
    printf "Usage: sh %s [-v|--verbose] [-q|--quiet]  [-r|--random <file>] <new_string> [-h| --help] [-p|--path] \n" "$0" >&2
    exit 0
fi

# Parse arguments
# getops couldn't be used here bc. it doesn't support long options
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -p|--path) shift ; check_path "$1" ;;
        -h|--help) print_help ;;
        -v|--verbose) VERBOSE=true ;;
        -q|--quiet) QUIET=true ;;
        -r|--random) RANDOM_MODE=true;;
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
    input=$(shuf -n 1 $1)
else
    # Get the input string
    input=$(echo "$1")
fi 

# Clean up multiple and leading or trailing spaces
input=$(echo "$input" | tr -s ' '| sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

# Check that input contains NO line breaks or carriage returns
if [[ $input == *'\n'* ]] || [[ $input == *'\r'* ]]; then
    if [[ "$QUIET" = false ]]; then
        echo -e "\033[31mError: The input string cannot contain line breaks or carriage returns.\033[39m" >&2
    fi
    exit 1
fi

# Get the inner size of the speach bubble
bub_len=$((${#input}+1))

# replace all / with \/ to escape the slashes 
#(must happen after the count else escape char will be counted)
input=$(echo "$input" | sed 's/\//\\\//g')

# Make the top line "ˏ______ˎ"
top_line="ˏ$(printf '_%.0s' $(seq 1 $bub_len))ˎ"

# Make center text "( text )"
center_text="\( $input \)"

# Make the bottom line "`ˉˉˉˉˉˉ´"
bottom_line="\`$(printf 'ˉ%.0s' $(seq 1 $bub_len))\´"

# The Speach bubble has to be cut in two parts: 
# The first part will be in the ASCII file and the second part will be in the config file
# Default case for start part of the speach bubble 
start_top_line="$top_line"
start_center_text="$center_text"
start_bottom_line="$bottom_line"
# Deafault case for end part of the speach bubble
end_top_line=""
end_center_line=""
end_bottom_line=""

# If input string was not empty
if [ "$bub_len" -gt 1 ]; then
    # Get the 4 first chars of the lines
    start_top_line=${top_line:0:4}
    start_center_text=${center_text:0:5}
    start_bottom_line=${bottom_line:0:4}
    # Get rest chars of the lines
    end_top_line=${top_line: 4}
    end_center_line=${center_text: 5}
    end_bottom_line=${bottom_line: 4}
fi

# If the text part that gets rendered though the neofetch conf (using prin) 
# has a leading space, let it get rendered as ascii instead (prin does not render leading spaces)
if [[ $end_center_line =~ ^[[:space:]].* ]]; then
    start_center_text="$center_text"
    end_center_line="" #This will print a single whitespace overlapping the ascii
    # if input is longer than 29 charachters the spacing will be off
    if [[ $bub_len -gt 29 ]]; then
        # increase gapsize by one for each char more than 29
        chage_in_gap=$(($bub_len - 29))
        GAP_SIZE=$(($GAP_SIZE - $chage_in_gap))
    fi
fi

# Path to the ASCII file and the configuration file
ascii_file="$CONF_PATH/bmo.txt"
conf_file="$CONF_PATH/bmofetch.conf"

# Make the first part of the speak bubble in the ascii file (2 chars of the text)
replace_string_in_file "$ascii_file" "1" "\\\u001b[1m                   $start_top_line"
replace_string_in_file "$ascii_file" "2" "\\\033[36m     ˏ________ˎ   \\\033[39m$start_center_text"
replace_string_in_file "$ascii_file" "3" "\\\033[36m    \\/|\\\033[39m ______\\\033[36m | \\\033[39m \\/ $start_bottom_line"

# Make the end part of the speak bubble in the conf file (form the third text char to the end)
replace_string_in_file "$conf_file" "5" "    prin \"$end_top_line\""
replace_string_in_file "$conf_file" "6" "    prin \"$end_center_line\"" 
replace_string_in_file "$conf_file" "7" "    prin \"$end_bottom_line\""

# Search for the line starting with "image_source" in conf file
source_line_number=$(grep -n "^image_source" "$conf_file" | cut -d: -f1)
# Search for the line with gap=x in conf file
gap_line_number=$(grep -n "^gap=" "$conf_file" | cut -d: -f1)

# replace everey / with \\/ to escape the slashes
ascii_file=$(echo "$ascii_file" | sed 's/\//\\\//g')
# replace the image_source line in the conf file with the new image_source
replace_string_in_file "$conf_file" "$source_line_number" "image_source=$ascii_file"
# replace the gap line in the conf file with the new gap
replace_string_in_file "$conf_file" "$gap_line_number" "gap=$GAP_SIZE"

# Success message (if not quiet)
if [[ "$QUIET" = false ]]; then
    echo -e "\033[32mSuccess: BMO now says \"$input\"\033[39m"
fi

exit 0