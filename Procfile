release: bin/rails db:migrate
web: bin/rails server -p $PORT
js: yarn build --watch
worker: bundle exec sidekiq -C config/sidekiq.yml