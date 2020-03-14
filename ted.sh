#!/bin/sh
# A line based text editor written for POSIX shells, using as few core utils as possible
# Autor: Travis Dowd
# Date Started: 10-31-2019
#
# Dependancies: POSIX Shell, sed, tail, echo, cp, mv
#
# Ideas:
#  - Add .tedrc (have colors read from there)
#  - Try and write own verions of: tail, mv, cp, and echo
#

# cat
type_out(){
    count=0
    while IFS= read -r line; do
	printf '%s\n' "$line"
	count=$((count+1))
    done < "$1"
}
# cat with line numbers
type_line_num(){
    count=0
    while IFS= read -r line; do
	if [ "$count" -lt "10" ]
	then
	    printf ' %d ' "$count"
	    printf '  %s\n' "$line"
	    count=$((count+1))
	else
	    printf '%d ' "$count"
	    printf '  %s\n' "$line"
	    count=$((count+1))
    fi
    done < "$1"
}
# head
type_top(){
    while IFS= read -r line; do
	printf '%s\n' "$line"
	i=$((i+1))
	[ "$i" = "$1" ] && return
    done < "$2"
    [ -n "$line" ] && printf %s "$line"
}
# wc -l
line_count(){
    count=0
    while IFS= read -r line; do
	count=$((count+1))
    done < "$1"
    echo $count
}
#
# main
#
case $1 in
    -h)  # display basic help
	printf "List of available modes:\\n"
	printf "\\t o - output file\\n"
	printf "\\t a - append to file\\n"
	printf "\\t r - replace line\\n"
	printf "\\t i - insert at line number\\n"
	printf "\\t d - delete specific line number\\n"
	printf "\\t h - help\\n"
	;;
    -o)  # output file
	type_line_num "$2"
	;;
    -a)  # append to file, add new line
	printf "Text: "
	read -r APPEND
	echo "$APPEND" >> "$2"
	;;
    -d)  # delete line
	printf "Line Number: "
	read -r DEL_LINE
	if [ "$DEL_LINE" -eq "0" ]; then
	    sed -i "$DEL_LINE d" "$2"
	elif [ "$DEL_LINE" -gt "0" ]; then
	    DEL_LINE=$((DEL_LINE+1))
	    sed -i "$DEL_LINE d" "$2"
	fi
	;;
    -r)  # replace at line number
	printf "Line Number: "
	read -r REP_LINE
	printf "Text: "
	read -r REP_TEXT
	LINUM=$((REP_LINE+1))
	sed -i "$LINUM s/.*/$REP_TEXT/g" "$2"
	;;
    -i)  # insert at line number
	touch backup
	printf "Line Number: "
	read -r INS_LINE
	printf "Text: "
	read -r INS_TEXT
	if [ "$INS_LINE" -eq "0" ]; then	  
	    echo "$INS_TEXT" > backup
	    type_out "$2" >> backup
	elif [ "$INS_LINE" -gt "0" ]; then
	    cp "$2" backup
	    LINE1=$(line_count "$2")
	    LINE2=$((LINE1-INS_LINE))
	    type_top "$INS_LINE" "$2" > backup
	    echo "$INS_TEXT" >> backup
	    tail -n "$LINE2" "$2" >> backup
	fi
	mv backup "$2"
	;;
    f)  # testing
	printf "Top line to print: "
	read -r TOP_NUM
	type_top "$TOP_NUM" "$2"
	;;
    -*)  # any other cmd, error checking
	printf "ERROR: Unkown mode...\\n"
	;;
esac

