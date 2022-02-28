// Entry point for the build script in your package.json

import { Turbo } from "@hotwired/turbo-rails"
// This disables Turbo throughout the app, allowing enabling on a per element basis with `data-turbo="true"`. REF: https://github.com/hotwired/turbo-rails#navigate-with-turbo-drive
Turbo.session.drive = false // TODO: Decide if I want to turn this on

import "./controllers"