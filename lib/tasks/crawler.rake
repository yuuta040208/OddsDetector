# frozen_string_literal: true

namespace :crawler do
  namespace :jra do
    desc 'JRAのレース情報を定期的に publish する'
    task :publish => :environment do
      Crawler::JRA::Runner.publish
    end

    desc 'JRAのレース情報を定期的に subscribe する'
    task :subscribe => :environment do
      Crawler::JRA::Runner.subscribe
    end
  end
end
