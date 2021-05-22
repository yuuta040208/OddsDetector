# frozen_string_literal: true

class Crawler::JRA::TopPage
  def self.create_target_urls(document)
    race_ids = document.css('div.rCorner > a').map { |element| element.attributes['href'].value.split('/').compact.last.to_i }
    race_ids.map { |race_id| Crawler::JRA::TargetUrl.new(race_id: race_id) }
  end
end
