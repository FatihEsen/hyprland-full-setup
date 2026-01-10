#!/bin/bash
CITY="Altinordu"
weather=$(curl -s "https://wttr.in/${CITY}?format=j1")
if [ -z "$weather" ]; then
    echo "{\"text\": \"N/A\", \"tooltip\": \"Hava durumu alınamadı\"}"
    exit
fi
temp=$(echo "$weather" | jq -r '.current_condition[0].temp_C')
desc=$(echo "$weather" | jq -r '.current_condition[0].weatherDesc[0].value')
code=$(echo "$weather" | jq -r '.current_condition[0].weatherCode')
case $code in
    113) icon="" ;; 116) icon="" ;; 119) icon="" ;; 122) icon="" ;; 143) icon="" ;;
    176) icon="" ;; 200) icon="" ;; 227) icon="" ;; 230) icon="" ;; 248) icon="" ;;
    260) icon="" ;; 263) icon="" ;; 266) icon="" ;; 281) icon="" ;; 284) icon="" ;;
    293) icon="" ;; 296) icon="" ;; 299) icon="" ;; 302) icon="" ;; 305) icon="" ;;
    308) icon="" ;; 311) icon="" ;; 314) icon="" ;; 317) icon="" ;; 320) icon="" ;;
    323) icon="" ;; 326) icon="" ;; 329) icon="" ;; 332) icon="" ;; 335) icon="" ;;
    338) icon="" ;; 350) icon="" ;; 353) icon="" ;; 356) icon="" ;; 359) icon="" ;;
    362) icon="" ;; 365) icon="" ;; 368) icon="" ;; 371) icon="" ;; 374) icon="" ;;
    377) icon="" ;; 386) icon="" ;; 389) icon="" ;; 392) icon="" ;; 395) icon="" ;;
    *)   icon="" ;;
esac
echo "{\"text\": \"$icon $temp°C\", \"tooltip\": \"Hava: $desc\nŞehir: $CITY\"}"
