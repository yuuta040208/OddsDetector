# frozen_string_literal: true

Rails.app_class.load_tasks

class JRAJob < ActiveJob::Base
  def perform
    Rake::Task['crawler:jra'].invoke
  rescue OpenURI::HTTPError => e
    p e
    sleep(60 * 30)
    Rake::Task['crawler:jra'].invoke
  end
end
