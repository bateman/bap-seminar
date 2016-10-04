# -*- coding: utf-8 -*-

# Define here the code for scraping content

from scrapy import Spider
from wikiSpider.items import WikispiderItem


class ArticleSpider(Spider):
    name = "article"
    allowed_domains = ['en.wikipedia.org']
    start_urls = ['https://en.wikipedia.org/wiki/Scrapy',
                  'http://en.wikipedia.org/wiki/Python_%28programming_language%29']

    def parse(self, response):
        item = WikispiderItem()
        # ...
        return item
