#!/bin/sh

. ./util.sh

while read line
do
	#GENERAL;CMD;hostname;null;Machine hostname;
	CLASS=$(echo ${line} | cut -f 1 -d ';')
	TYPE=$(echo ${line} | cut -f 2 -d ';')
	CONTENT=$(echo ${line} | cut -f 3 -d ';')
	PREPARSER=$(echo ${line} | cut -f 4 -d ';')
	DESCRIPTION=$(echo ${line} | cut -f 5 -d ';')


	if [ -z "${CLASS}" -o -z "${TYPE}" -o -z "${CONTENT}" -o -z "${PREPARSER}" -o -z "${DESCRIPTION}" ]; then
		echo WARN AGENDA RECORD SKIP
		continue;
	fi

	echo INFO AGENDA RECORD OK
	echo INFO CLASS ${CLASS} TYPE ${TYPE} CONTENT ${CONTENT} PREPARSER ${PREPARSER} DESCRIPTION ${DESCRIPTION}

	# robimy wszystko po SED

	if [ "${TYPE}" == "CMD" ]; then
		# obcinamy concent tylko n command
		CMD=$(echo ${CONTENT} | cut -f 1 -d ' ')
		print_cmd ${CMD} ${CLASS}

		checkC=$(check_command ${CMD})		# czy command daje ok

		if [ $checkC -eq 0 ]; then
			PCMD=$(which ${CMD} 2> /dev/null)	# full path
		else
			PCMD=$(get_command_path ${CMD})		# full path z reki dodany dir
		fi


		if [ -z "${PCMD}" ];then
			echo "brak comendy"
			continue
		fi

		PCONTENT=$(echo ${CONTENT} | sed s:$CMD:$PCMD:g)

		# out

		echo ${PCMD} 			| sed 's/^/PATH - /g'
		file ${PCMD} 			| sed 's/^/FILE - /g'
		ls -las ${PCMD} 		| sed 's/^/LIST - /g'
		${PCMD} --help 		2>&1 	| sed 's/^/HELP1 - /g'
		${PCMD} -h 		2>&1 	| sed 's/^/HELP2 - /g'
		${PCMD} -V 		2>&1 	| sed 's/^/VERSION1 - /g'
		${PCMD} --version 	2>&1 	| sed 's/^/VERSION2 - /g'
		echo ${PCONTENT}		| sed 's/^/CMD - /g'
		${PCONTENT} 		2>&1	| sed 's/^/OUTPUT - /g'

	elif [ "${TYPE}" == "FILE" ]; then

		file ${CONTENT}			| sed 's/^/FILE - /g'
		ls -las ${CONTENT}		| sed 's/^/LIST - /g'
		wc ${CONTENT}			| sed 's/^/STATS - /g'
		md5sum ${CONTENT}		| sed 's/^/HOSH - /g'
		cat ${CONTENT}			| sed 's/^/CONTENT - /g'
		
	fi

done < ${AGENDA}

