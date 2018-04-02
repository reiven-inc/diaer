module ApplicationHelper
  def html_br(s)
    h(s).gsub(/(\r\n?)|(\n)/, '<br>').html_safe
  end

  def twitter_user_url(screen_name)
    "https://twitter.com/#{screen_name}"
  end

  def twitter_tweet_url(screen_name, id)
    "https://twitter.com/#{screen_name}/status/#{id}"
  end

  def text_with_link(text)
    URI.extract(text, %w[http https]).uniq.each do |url|
      anchor = ''
      anchor << '<a href=' << url << ' target="_blank">' << url << '</a>'
      text.gsub!(url, anchor)
    end
    text
  end

  # 引数の時間が現時点から見てどの範囲にあるか
  def time_category(date = nil)
    return if date.nil?
    seconds = (Time.zone.now - date).round
    # 1年以上前
    years = seconds / (60 * 60 * 24 * 365)
    return "#{years}年前" if years.positive?
    # 1ヶ月以上前
    months = seconds / (60 * 60 * 24 * 30)
    return "#{months}ヶ月前" if months.positive?
    # 1週間以上前
    weeks = seconds / (60 * 60 * 24 * 7)
    return "#{weeks}週間前" if weeks.positive?
    # 1日以上前または現在と同じ日付ではない
    days = seconds / (60 * 60 * 24)
    return "#{WEEK_JP[date.wday]}曜日" if days.positive? || date.beginning_of_day != Time.zone.now.beginning_of_day
    # 上記にあてはまらない
    '今日'
  end
end
