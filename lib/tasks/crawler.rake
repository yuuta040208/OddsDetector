# frozen_string_literal: true

namespace :crawler do
  desc 'JRAのオッズ情報をクローリング'
  task :jra => :environment do
    Crawler::JRA::Runner.new.execute
  end

  desc '南関競馬のオッズ情報をクローリング'
  task :nankan => :environment do
    Crawler::Nankan::Runner.new.execute
  end
end
