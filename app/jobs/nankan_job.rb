# frozen_string_literal: true

Rails.app_class.load_tasks

class NankanJob < ActiveJob::Base
  def perform
    Rake::Task['crawler:nankan'].invoke
  end
end
