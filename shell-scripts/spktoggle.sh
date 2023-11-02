#!/bin/bash

# Script used to manually toggle between headphone jack and speaker
# Can be triggered from a key daemon like ogage

spktoggle=$(amixer | grep "Item0: 'SPK'")

if [ "$(cat /home/ark/.config/.DEVICE)" == "RGB30" ] || [ "$(cat /home/ark/.config/.DEVICE)" == "RK2023" ]; then
  presses="spktogglepress1 spktogglepress2 spktogglepress3 spktogglepress4 spktogglepress5"

  if [ -z "$spktoggle" ]
  then
    for press in $presses
    do
      if [ -z $(find "/dev/shm/${press}" -cmin -0.05  2>/dev/null) ]; then
        touch /dev/shm/${press}
        exit 0
      fi
    done
  fi

  if [ ! -z $(find "/dev/shm/spktogglepress5" -cmin -0.05  2>/dev/null) ] || [ ! -z "$spktoggle" ]; then
    if [ -z "$spktoggle" ]
    then
        amixer -q sset 'Playback Path' SPK
        rm -f /dev/shm/spktogglepress*
    else
        amixer -q sset 'Playback Path' HP
        rm -f /dev/shm/spktogglepress*
    fi
  fi
else
  if [ -z "$spktoggle" ]
  then
      amixer -q sset 'Playback Path' SPK
  else
      amixer -q sset 'Playback Path' HP
  fi
fi
