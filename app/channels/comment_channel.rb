# frozen_string_literal: true

class CommentChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_#{params[:question_id]}_comments"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
