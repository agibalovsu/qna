# frozen_string_literal: true

class AnswerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_#{params[:question_id]}_answers"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
