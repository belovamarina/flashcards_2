class WebNotificationsChannel < ApplicationCable::Channel
  def subscribed
    # stream_for current_user
    stream_from "web_notification_channel:#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
