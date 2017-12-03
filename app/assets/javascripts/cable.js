// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using
//   the `rails generate channel` command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

/* global ActionCable */
(() => {
  if (!this.App) { this.App = {}; }
  this.App.cable = ActionCable.createConsumer();
}).call(this);
