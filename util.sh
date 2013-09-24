#!/bin/sh


AGENDA=./agenda

EXE_PATH_LIST='/bin /usr/bin /usr/sbin'


check_command()
{
        CMD=$(command -v $1 > /dev/null 2>&1)
        RES=$?

        if [ $RES -ne 0 ]; then
		echo 1
        else
		echo 0
        fi
}



##################


print_cmd ()
{
	echo print_cmd
	echo "${2} - ${1}"
}

#######################

get_command_path ()
{
	for item in `echo "${EXE_PATH_LIST}"`
	do
		if [ -f ${item}/${1} ]; then
			echo ${item}/${1}
			break
		fi
	done
}

