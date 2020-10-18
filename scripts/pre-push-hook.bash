#!/usr/bin/env bash

# REF: https://medium.com/better-programming/git-hooks-for-your-rails-app-to-run-rubocop-brakeman-and-rspec-on-push-or-commit-ab51cd65e713

echo 'Running RSpec before pushing...'
bundle exec rspec

if [ $? -ne 0 ]; then
  echo 'RSpec must pass before pushing.'
  exit 1
fi