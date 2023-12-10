#!/bin/bash

##################################################################
# Created by Christian Haitian for use to easily update          #
# various standalone emulators, libretro cores, and other        #
# various programs for the RK3566 platform for various Linux     #
# based distributions.                                           #
# See the LICENSE.md file at the top-level directory of this     #
# repository.                                                    #
##################################################################

cur_wd="$PWD"
bitness="$(getconf LONG_BIT)"

	# Libretro ep128emu build
	if [[ "$var" == "ep128emu" || "$var" == "all" ]] && [[ "$bitness" == "64" ]]; then
	 cd $cur_wd
	  if [ ! -d "ep128emu/" ]; then
		git clone --recursive https://github.com/libretro/ep128emu-core.git ep128emu
		if [[ $? != "0" ]]; then
		  echo " "
		  echo "There was an error while cloning the libretro git.  Is Internet active or did the git location change?  Stopping here."
		  exit 1
		 fi
		cp patches/ep128emu-patch* ep128emu/.
	  fi

	 cd ep128emu/
	 
	 ep128emu_patches=$(find *.patch)
	 
	 if [[ ! -z "$ep128emu_patches" ]]; then
	  for patching in ep128emu-patch*
	  do
		   patch -Np1 < "$patching"
		   if [[ $? != "0" ]]; then
			echo " "
			echo "There was an error while applying $patching.  Stopping here."
			exit 1
		   fi
		   rm "$patching" 
	  done
	 fi

	  make -j$(nproc)

	  if [[ $? != "0" ]]; then
		echo " "
		echo "There was an error while building the newest lr-ep128emu core.  Stopping here."
		exit 1
	  fi

	  strip ep128emu_core_libretro.so

	  if [ ! -d "../cores64/" ]; then
		mkdir -v ../cores64
	  fi

	  cp ep128emu_core_libretro.so ../cores64/.

	  gitcommit=$(git log | grep -m 1 commit | cut -c -14 | cut -c 8-)
	  echo $gitcommit > ../cores$(getconf LONG_BIT)/$(basename $PWD)_core_libretro.so.commit

	  echo " "
	  echo "ep128emu_libretro.so has been created and has been placed in the rk3566_core_builds/cores64 subfolder"
	fi
