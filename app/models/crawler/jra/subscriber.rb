# frozen_string_literal: true

class Crawler::JRA::Subscriber
  def execute
    # スクレイピング対象が1件もpublishされていない場合は早期リターンしてOK
    return if JRA::ScrapingTarget.count == 0

    # DBをロックして ScrapingTarget を1つポップ、ポップしたらすぐにロックを解除する
    JRA::ScrapingTarget.transaction do
      @scraping_target = JRA::ScrapingTarget.eager_load(:race).order('jra_races.number').first
      @scraping_target.destroy!
    end

    begin
      # スクレイピング対象をブロックに渡す
      yield(@scraping_target)
    rescue => e
      # 例外が発生した場合はスクレイピング対象を新しいレコードとして元に戻す
      @scraping_target.dup.save!
      p e
    end
  end
end
