#!/bin/sh

TCICLOVERDIR="$HOME"/src/CloverBootloader

setuser() {
  echo "set user info start.."
  cd "${TRAVIS_BUILD_DIR}"
  git config --global user.email "$GIT_EMAIL"
  git config --global user.name "$GIT_NAME"
  echo "set user info end"
}

exportVariables() {
  echo "export variables start.."
  cd "${TCICLOVERDIR}"
  export CLOVER_REV="r$(cat vers.txt)"
  export CLOVER_HASH="$(git rev-parse --short HEAD)"
  echo "export variables end"
}


checkTags() {
  echo "check tags start.."
  cd "${TRAVIS_BUILD_DIR}"
  local tags=($(git tag))

  for tag in "${tags[@]}"
  do
    if [[ "$tag" == "${CLOVER_REV}-*" ]]; then
      git push --delete origin $tag
      git tag -d $tag
    fi
  done
  echo "check tags end"
}

tag() {
  echo "tag changes start.."
  cd "${TRAVIS_BUILD_DIR}"
  echo "$CLOVER_REV $CLOVER_HASH" > .lastTag
  echo "$(date)" >> .lastTag
  export TRAVIS_TAG="${CLOVER_REV}-${CLOVER_HASH}"
  git add .
  git commit -am "Travis build: ${TRAVIS_TAG}"
  git tag "${TRAVIS_TAG}"
  git push https://${GIT_NAME}:${GH_TOKEN}@github.com/${GIT_NAME}/DailyClover.git --tags
  echo "tag changes end"
}

exportVariables
setuser
checkTags
tag
