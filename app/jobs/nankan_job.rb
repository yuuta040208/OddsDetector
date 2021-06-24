# frozen_string_literal: true

Rails.app_class.load_tasks

class NankanJob < ActiveJob::Base
  def perform
    Rake::Task['crawler:nankan'].invoke
  rescue ScrapingTargetNotExistError
    # finish
  rescue StandardError => e
    p e
    sleep(60 * 30)
    NankanJob.perform_now
  end
end
