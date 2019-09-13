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
  export CLOVER_REV="$(cat vers.txt)"
  export CLOVER_HASH="$(git rev-parse --short HEAD)"
  echo "export variables end"
}

tag() {
  echo "tag changes start.."
  cd "${TRAVIS_BUILD_DIR}"
  echo "" > .lastTag
  if grep -q "${CLOVER_REV}-${CLOVER_HASH}" .lastTag; then
    echo "${CLOVER_REV}-${CLOVER_HASH} already exist"
    export TRAVIS_TAG=""
  else
    export TRAVIS_TAG="${CLOVER_REV}-${CLOVER_HASH}"
#    checkTags
    echo "${TRAVIS_TAG}" > .lastTag
    echo "$(date)" >> .lastTag
    echo "${TRAVIS_TAG} will be created"
    git add .
    git commit -am "Travis build: ${TRAVIS_TAG}"
    git tag "${TRAVIS_TAG}"
    git push https://${GIT_NAME}:${GH_TOKEN}@github.com/${GIT_NAME}/DailyClover.git --tags
    git fetch
  fi
  echo "tag changes end"
}

checkTags() {
  echo "check tags start.."
  cd "${TRAVIS_BUILD_DIR}"
  local tags=($(git tag))

  for tag in "${tags[@]}"
  do
    if [[ "$tag" == "${CLOVER_REV}"-* ]]; then
      git push --delete origin $tag
      git tag -d $tag
    fi
  done
  echo "check tags end"
  tag
}

exportVariables
setuser
tag
