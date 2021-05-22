# frozen_string_literal: true

class Crawler::JRA::TopPage
  def self.create_target_urls(document)
    race_ids = document.css('li.RaceList_DataItem > a:nth-child(1)').map { |element| element.attributes['href'].value.delete('^0-9') }
    race_ids.map { |race_id| Crawler::JRA::TargetUrl.new(race_id: race_id) }
  end
end
