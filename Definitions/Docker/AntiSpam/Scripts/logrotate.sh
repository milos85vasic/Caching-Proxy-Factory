#!/bin/sh

logs=/var/log
logFile=rspamd.log
rspamdLog="$logs/$logFile"

if test -e ${rspamdLog}
then

  cp ${rspamdLog} "${logs}/$(($(date +%s%N)/1000000))_$logFile"
  echo "Log initialized: $(date)" > ${rspamdLog}
  find ${logs} -name "*_$logFile" -mtime +120 -exec rm -f {} \; >> ${rspamdLog}
  echo "Beginning of log file:" >> ${rspamdLog}
else

  echo "Log not yet available for archiving: $(date)" >> ${rspamdLog}
fi

sleep 604800; sh /logrotate.sh &