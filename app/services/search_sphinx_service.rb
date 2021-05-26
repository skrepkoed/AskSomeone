class SearchSphinxService
  RESOURCES={'Questions'=>Question,'Answers'=>Answer,'Comments'=>Comment,'Users'=>User,'All'=>ThinkingSphinx}
  def self.search(params_search)
    RESOURCES[params_search[:resources]].search params_search[:search]
  end
end