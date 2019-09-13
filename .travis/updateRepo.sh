#!/bin/sh

TCICLOVERDIR="$HOME"/src/CloverBootloader
INITDIR="$TRAVIS_BUILD_DIR"/DailyClover
setuser() {
  cd "${TCICLOVERDIR}"
  git config --global user.email "travis@travis-ci.com"
  git config --global user.name "Travis CI"
}

exportVariables() {
  cd "${TCICLOVERDIR}"
  export CLOVER_REV="r$(cat vers.txt)"
  export CLOVER_HASH="$(git rev-parse --short HEAD)"
}


checkTags() {
  cd "${INITDIR}"
  local tags=($(git tag))

  for tag in "${tags[@]}"
  do
    if [[ "$tag" == "${CLOVER_REV}-*" ]]; then
      git push --delete origin $tag
      git tag -d $tag
    fi
  done
}

tag() {
  cd "${INITDIR}"
  echo "$CLOVER_REV $CLOVER_HASH" > .lastTag
  echo "$(date)" >> .lastTag
  export TRAVIS_TAG="${CLOVER_REV}-${CLOVER_HASH}"
  git add .
  git commit -am "Travis build: ${TRAVIS_TAG}"
  git push origin master
  git tag "${TRAVIS_TAG}"
}

exportVariables
setuser
checkTags
tag
