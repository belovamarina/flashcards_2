App.web_notifications = App.cable.subscriptions.create "WebNotificationsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#notice_block').html("<div class=\"alert alert-warning alert-dismissible\" role=\"alert\">" + data['message'] + "</div>")
    if data['card']
      $('#middle').prepend("<div class=\"alert alert-success alert-dismissible\" role=\"alert\">" + data['card'] + "</div>")
