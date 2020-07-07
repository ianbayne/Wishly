release: bin/rails db:migrate
web: bin/rails server -p $PORT
worker: bundle exec sidekiq -C config/sidekiq.yml