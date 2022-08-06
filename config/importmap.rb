# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'jquery', to: 'jquery.min.js', preload: true
pin 'jquery-ui', to: 'jquery-ui.js', preload: true
pin '@rails/ujs', to: 'https://ga.jspm.io/npm:@rails/ujs@7.0.3/lib/assets/compiled/rails-ujs.js'
pin 'popper', to: 'popper.js', preload: true
pin 'bootstrap', to: 'bootstrap.min.js', preload: true
pin 'activestorage', to: 'activestorage.js', preload: true
pin 'cocoon', to: 'cocoon.js', preload: true
pin '@rails/actioncable', to: 'actioncable.esm.js'
pin_all_from 'app/javascript/channels', under: 'channels'
