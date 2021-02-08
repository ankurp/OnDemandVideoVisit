// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import { Turbo } from "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import 'controllers';
require('local-time').start();
require('bootstrap');
require('data-confirm-modal');

window.Rails = Rails
window.Turbo = Turbo
Rails.start()
ActiveStorage.start()

$(document).on('turbo:load', () => {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
});
