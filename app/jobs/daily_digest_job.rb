# frozen_string_literal: true

class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    DailyDigestService.new.send_digest
  end
end
