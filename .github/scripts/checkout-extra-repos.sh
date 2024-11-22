#!/bin/sh

# Checkout integrated dependency repositories

echo "Parsing JSON repository list"
REPO_LIST=$(echo "$REPOS" | jq -r '.[]')
echo "Checking out $REPO_LIST using minimal resources"
for repo in $REPO_LIST; do
  echo "::group::Initializing repository-group/$repo"
  echo -e "\e[34mgit init repository-group/$repo\e[0m"
  git init repository-group/$repo
  echo "::endgroup::"
  cd repository-group/$repo

  echo "Adding remote for $repo"
  if [ -n "$ROSIE_PERSONAL_ACCESS_TOKEN" ]; then
    echo "Using ihmc-rosie personal access token"
    git remote add origin https://"$ROSIE_PERSONAL_ACCESS_TOKEN"@github.com/ihmcrobotics/$repo.git
  else
    git remote add origin https://github.com/ihmcrobotics/$repo.git repository-group/$repo
  fi
  echo "Disabling automatic garbage collection"
  git config --local gc.auto 0
  echo "git -c protocol.version=2 fetch --no-tags --prune --no-recurse-submodules --depth 1 origin $CURRENT_REF"
  git -c protocol.version=2 fetch --no-tags --prune --no-recurse-submodules --depth 1 origin $CURRENT_REF
  echo "git checkout --progress --force FETCH_HEAD"
  git checkout --progress --force FETCH_HEAD
  cd ../../
done