#!/bin/bash

# vector sigma 2019
# download and add AptioMemoryFix.efi/AptioInputFix.efi in the pkg

# $1 = path to Clover
# $2 = toolchain (XCODE8, GCC53 etc.)

# This script is an expansion for buildme, and require the above arguments to be functional

link=https://github.com/acidanthera/AptioFixPkg/releases/download/R27/AptioFix-R27-RELEASE.zip

export DIR_MAIN=${DIR_MAIN:-~/src}
export DIR_TOOLS=${DIR_TOOLS:-$DIR_MAIN/tools}
export DIR_DOWNLOADS=${DIR_DOWNLOADS:-$DIR_TOOLS/download}

if [[ ! -x "${1}"/ebuild.sh ]]; then
  echo "can't find Clover"
fi

set -e
mkdir -p "${DIR_DOWNLOADS}"
cd "${DIR_DOWNLOADS}"

if [[ ! -f AptioMemoryFixR27.zip ]]; then
  curl $link -L -o AptioMemoryFixR27.zip
fi

if [[ -d "${1}"/CloverPackage/CloverV2/EFI/CLOVER/drivers/off/UEFI/MemoryFix ]]; then
  cd "${1}"/CloverPackage/CloverV2/EFI/CLOVER/drivers/off/UEFI/MemoryFix
  unzip -j "${DIR_DOWNLOADS}"/AptioMemoryFixR27.zip Drivers/AptioMemoryFix.efi
else
  echo "ERROR: cannot add AptioMemoryFix.efi because ../CLOVER/drivers/UEFI does not exist!"
  sleep 2
fi

if [[ -d "${1}"/CloverPackage/CloverV2/EFI/CLOVER/drivers/off/UEFI/FileVault2 ]]; then
  cd "${1}"/CloverPackage/CloverV2/EFI/CLOVER/drivers/off/UEFI/FileVault2
  unzip -j "${DIR_DOWNLOADS}"/AptioMemoryFixR27.zip Drivers/AptioInputFix.efi
else
  echo "ERROR: cannot add AptioInputFix.efi because ../CLOVER/drivers/off/UEFI/FileVault2 does not exist!"
  sleep 2
fi


