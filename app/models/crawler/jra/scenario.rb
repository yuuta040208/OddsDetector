# frozen_string_literal: true

class Crawler::JRA::Scenario
  class << self
    def daily(session, url, date)
      session.visit(url)
      # オッズ 開催選択ページ
      session.find(:xpath, '/html/body/div/div[5]/div/ul/li[3]/a').click

      hold_selection_page_document = Nokogiri::HTML(session.html)
      saturday_css_paths, sunday_css_paths = hold_selection_page_document.css('div.link_list.multi.div3.center').map { |div| div.css('a').map(&:css_path) }
      paths = if date.wday == 0
               sunday_css_paths
             elsif date.wday == 6
               saturday_css_paths
             else
               raise StandardError, 'Invalid date'
             end

      paths.each do |race_list_page_css_path|
        # オッズ レース選択ページ
        session.find(:css, race_list_page_css_path).click

        race_selection_page_document = Nokogiri::HTML(session.html)
        first_race = race_selection_page_document.css('th.race_num a').first

        # 単勝・複勝オッズ（馬番順）ページ（1R）
        session.find(:css, first_race.css_path).click
        race_detail_page_document = Nokogiri::HTML(session.html)

        yield(race_detail_page_document)

        race_detail_page_document.css('ul.nav.race-num.mt15').first.css('li > a').each.with_index(1) do |a, race_number|
          next if race_number == 1

          # 単勝・複勝オッズ（馬番順）ページ（2R~）
          session.find(:css, a.css_path).click
          race_detail_page_document = Nokogiri::HTML(session.html)

          yield(race_detail_page_document)
        end

        session.find(:xpath, '/html/body/div/div[4]/div[3]/div/ul/li[3]/a').click
      end
    end

    def single(session, url)
      session.visit(url)
      # オッズ 開催選択ページ
      session.find(:xpath, '/html/body/div/div[5]/div/ul/li[3]/a').click

      description = ''
      Crawler::JRA::Subscriber.single do |_description, scraping_target|
        if description != _description
          session.find(:xpath, '/html/body/div/div[4]/div[3]/div/ul/li[3]/a').click if description.present?

          session.find(:css, 'div.link_list.multi.div3.center a', text: _description).click

          race_selection_page_document = Nokogiri::HTML(session.html)
          css_path = race_selection_page_document.css('div.tanpuku').map(&:css_path)[scraping_target.race_number - 1]

          session.find(:css, css_path).click
          race_detail_page_document = Nokogiri::HTML(session.html)

          yield(race_detail_page_document, scraping_target.jra_race_id)

          description = _description
        else
          race_detail_page_document = Nokogiri::HTML(session.html)
          css_path = race_detail_page_document.css('ul.nav.race-num.mt15').first.css('li > a')[scraping_target.race_number - 1].css_path

          session.find(:css, css_path).click
          race_detail_page_document = Nokogiri::HTML(session.html)

          yield(race_detail_page_document, scraping_target.jra_race_id)
        end
      end
    end

    def quinella(session, url)
      session.visit(url)
      # オッズ 開催選択ページ
      session.find(:xpath, '/html/body/div/div[6]/div/ul/li[3]/a').click

      description = ''
      Crawler::JRA::Subscriber.quinella do |_description, scraping_target|
        if description != _description
          session.find(:xpath, '/html/body/div/div[4]/div[3]/div/ul/li[3]/a').click if description.present?

          session.find(:css, 'div.link_list.multi.div3.center a', text: _description).click

          race_selection_page_document = Nokogiri::HTML(session.html)
          css_path = race_selection_page_document.css('div.umaren').map(&:css_path)[scraping_target.race_number - 1]

          session.find(:css, css_path).click
          race_detail_page_document = Nokogiri::HTML(session.html)

          yield(race_detail_page_document, scraping_target.jra_race_id)

          description = _description
        else
          race_detail_page_document = Nokogiri::HTML(session.html)
          css_path = race_detail_page_document.css('ul.nav.race-num.mt15').first.css('li > a')[scraping_target.race_number - 1].css_path

          session.find(:css, css_path).click
          race_detail_page_document = Nokogiri::HTML(session.html)

          yield(race_detail_page_document, scraping_target.jra_race_id)
        end
      end
    end

    def wide(session, url)
      session.visit(url)
      # オッズ 開催選択ページ
      session.find(:xpath, '/html/body/div/div[5]/div/ul/li[3]/a').click

      description = ''
      Crawler::JRA::Subscriber.wide do |_description, scraping_target|
        if description != _description
          session.find(:xpath, '/html/body/div/div[4]/div[3]/div/ul/li[3]/a').click if description.present?

          session.find(:css, 'div.link_list.multi.div3.center a', text: _description).click

          race_selection_page_document = Nokogiri::HTML(session.html)
          css_path = race_selection_page_document.css('div.wide').map(&:css_path)[scraping_target.race_number - 1]

          session.find(:css, css_path).click
          race_detail_page_document = Nokogiri::HTML(session.html)

          yield(race_detail_page_document, scraping_target.jra_race_id)

          description = _description
        else
          race_detail_page_document = Nokogiri::HTML(session.html)
          css_path = race_detail_page_document.css('ul.nav.race-num.mt15').first.css('li > a')[scraping_target.race_number - 1].css_path

          session.find(:css, css_path).click
          race_detail_page_document = Nokogiri::HTML(session.html)

          yield(race_detail_page_document, scraping_target.jra_race_id)
        end
      end
    end
  end
end
