atom_feed(language: 'ja-JP') do |feed|
  feed.title('DIAER [ディアー]｜結婚式の総合情報サイト')
  feed.subtitle('DIAER（ディアー）は、理想の結婚式を見つけるための「結婚式の総合情報サイト」です。結婚式場・ドレス・タキシード・ネイル・ブーケ・ウェディングアイテム・会場装飾・海外のトレンド・プロポーズ・ハネムーン・結婚の知識など、ウェディングに関する情報をお届けします！')
  feed.updated(@articles.first.checkpoint)

  @articles.each do |a|
    feed.entry(a, url: "#{SITE_ROOT}/#{a.id}", published: a.checkpoint) do |entry|
      entry.title(a.article_title)
      entry.summary(a.article_description, type: 'html')
    end
  end
end
