#!/bin/bash

# sample() {
#     echo " this is sample function"
# }

# sample 

stat(){
    echo "number of sessions opened : $(who | wc -l)"
    echo "todays date is : $(date +%F)"
    echo "load average of the system in last 1 minute: $(uptime | awk -F : '{print $5}' | awk -F , '{print $1}')"
}

echo "calling stat function"

stat