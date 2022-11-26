# frozen_string_literal: true

require 'timers'

class Crawler::JRA::Runner
  class ScrapingTargetNotExistError < StandardError; end

  class << self
    def publish
      periodically do
        crawl_race_info

        publisher = Crawler::JRA::Publisher.new
        publisher.execute # 未発走のレースを publish
        publisher.official # 確定したレースでまだ確定オッズを収集していないレースを publish
      end
    end

    def subscribe
      session = Crawler::JRA::Session.new
      scenario = Crawler::JRA::Scenario.new(session)

      periodically(1) do
        Crawler::JRA::Subscriber.new.execute do |scraping_target|
          p "#{scraping_target.race_description} #{scraping_target.race_number}R #{scraping_target.path} を収集しています..."

          # 対象ページのHTMLを取得
          html = scenario.target_page_html(scraping_target)

          # オッズ情報を取得
          odds = parse_odds_page(html, scraping_target)

          # オッズ情報を保存
          ActiveRecord::Base.transaction do
            odds.each(&:save!)
          end
        end
      end
    end

    private

    # ブロックを定期実行する
    def periodically(second = 60 * 5)
      timers = Timers::Group.new
      timers.every(second) do
        yield
      end

      loop { timers.wait }
    end

    # その日のレース情報がDBになかったら収集する
    def crawl_race_info
      Crawler::JRA::Scraper.daily unless JRA::Race.exist_race_info?(Date.today)
    end

    # レース詳細ページにあるオッズ情報をパースする
    def parse_odds_page(document, scraping_target)
      now = Time.current
      start_at = scraping_target.race_start_at
      crawled_at = start_at < now ? start_at : now

      case scraping_target.path.to_sym
      when :single
        [
          Crawler::JRA::Odds::Win.parse(document, scraping_target.race_id, crawled_at),
          Crawler::JRA::Odds::Place.parse(document, scraping_target.race_id, crawled_at)
        ].flatten
      when :quinella
        Crawler::JRA::Odds::Quinella.parse(document, scraping_target.race_id, crawled_at)
      when :wide
        Crawler::JRA::Odds::Wide.parse(document, scraping_target.race_id, crawled_at)
      else
        raise StandardError("未実装の馬券種別を検知しました: #{scraping_target.path}")
      end
    end
  end
end

