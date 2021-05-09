# frozen_string_literal: true

class Nankan::TopPage
  def self.create_target_urls(document, date)
    race_ids = document.css('a.racetable__nameTxt').map { |element| element.attributes['href'].value.split('/').last.to_i }
    today_race_ids = race_ids.select { |race_id| race_id.to_s.start_with?(date.strftime('%Y%m%d')) }
    today_race_ids.map { |race_id| Nankan::TargetUrl.new(race_id: race_id) }
  end
end
