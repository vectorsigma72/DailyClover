#!/bin/sh

checkTags() {
  echo "check tags start.."
  cd "${TRAVIS_BUILD_DIR}"
  local tags=($(git tag))

  git config --global user.email "$GIT_EMAIL"
  git config --global user.name "$GIT_NAME"

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


checkTags

