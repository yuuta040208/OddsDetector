# frozen_string_literal: true

class Crawler::JRA::Scenario
  HOST = 'https://jra.jp/'

  def initialize(session)
    @session = session

    freeze
  end

  def target_page_html(scraping_target)
    visit_odds_top_page
    visit_race_selection_page(scraping_target)
    visit_race_detail_page(scraping_target)
    html
  end

  private

  def visit_odds_top_page
    @session.visit(HOST)
    @session.find(:xpath, '//*[@id="quick_menu"]/div/ul/li[3]/a').click
  end

  def visit_race_selection_page(scraping_target)
    @session.find(:xpath, "//*[@id='main']//a[contains(text(), '#{scraping_target.race_description}')]").click
  end

  def visit_race_detail_page(scraping_target)
    case scraping_target.path.to_sym
    when :single
      visit_single_page(scraping_target)
    when :quinella
      visit_quinella_page(scraping_target)
    when :wide
      visit_wide_page(scraping_target)
    else
      raise new StandardError("未実装の馬券種別を検知しました: #{scraping_target.path}")
    end
  end

  def visit_single_page(scraping_target)
    @session.find(:xpath, "//*[@id='race_list']/tbody/tr[#{scraping_target.race_number}]/td[3]/div/div[1]/a").click
  end

  def visit_quinella_page(scraping_target)
    @session.find(:xpath, "//*[@id='race_list']/tbody/tr[#{scraping_target.race_number}]/td[3]/div/div[3]/a").click
  end

  def visit_wide_page(scraping_target)
    @session.find(:xpath, "//*[@id='race_list']/tbody/tr[#{scraping_target.race_number}]/td[3]/div/div[4]/a").click
  end

  def html
    Nokogiri::HTML(@session.html)
  end

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
  end
end
