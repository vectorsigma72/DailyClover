#!/bin/sh

TCICLOVERDIR=~/src/CloverBootloader

setuser() {
  printf "set user info start.."
  cd "${TRAVIS_BUILD_DIR}"
  git config --global user.email "$GIT_EMAIL"
  git config --global user.name "$GIT_NAME"
  printf " end\n"
}

exportVariables() {
  printf "export variables start.."
  cd "${TCICLOVERDIR}"
  export CLOVER_REV="$(cat vers.txt)"
  export CLOVER_HASH="$(git rev-parse --short HEAD)"
  echo "$CLOVER_REV" > ~/cloverRev
  printf " end\n"
}

commitTag() {
  echo "tag changes start.."
  cd "${TRAVIS_BUILD_DIR}"
  TRAVIS_TAG="${CLOVER_REV}-${CLOVER_HASH}"
  echo "${TRAVIS_TAG}" > .lastTag
  echo "$(date)" >> .lastTag
  echo "${TRAVIS_TAG} will be created"
  git add .
  git commit -am "Travis build: ${TRAVIS_TAG} $(date)"
  git tag "${TRAVIS_TAG}"
  git push origin master --tags
# git push https://${GIT_NAME}:${GH_TOKEN}@github.com/${GIT_NAME}/DailyClover.git --tags
  echo "tag changes end"
}

checkTags() {
  echo "check tags start.."
  cd "${TRAVIS_BUILD_DIR}"
  local tags=($(git tag))

  for t in "${tags[@]}"
  do
    if [[ "$t" == "${CLOVER_REV}"-* ]]; then
      echo "deleting old tag \"$t\""
      git tag -d $t
      git push --delete https://${GIT_NAME}:${GH_TOKEN}@github.com/${GIT_NAME}/DailyClover.git $t

    fi
  done
  echo "check tags end"
}

exportVariables
setuser
checkTags
commitTag

