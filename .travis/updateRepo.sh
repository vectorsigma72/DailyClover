#!/bin/sh

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

commit() {
  cd "${INITDIR}"
  echo "$CLOVER_REV $CLOVER_HASH" > .lastTag
  echo "$(date)" >> .lastTag
  git commit --message "Travis build: ${CLOVER_REV}-${CLOVER_HASH}"
  git tag "${CLOVER_REV}-${CLOVER_HASH}"
  git push
}

exportVariables
setuser
checkTags
commit
