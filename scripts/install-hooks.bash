#!/usr/bin/env bash

# REF: https://medium.com/better-programming/git-hooks-for-your-rails-app-to-run-rubocop-brakeman-and-rspec-on-push-or-commit-ab51cd65e713

GIT_DIR=$(git rev-parse --git-dir)

echo 'Installing hooks...'
# this command creates symlink to our pre-commit script
ln -s ../../scripts/pre-push-hook.bash $GIT_DIR/hooks/pre-push
echo 'Done!'