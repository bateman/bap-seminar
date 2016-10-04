# -*- coding: utf-8 -*-

# Define here the code for scraping content

from scrapy import Spider
from wikiSpider.items import Article


class ArticleSpider(Spider):
    name = "article"
    allowed_domains = ['en.wikipedia.org']
    start_urls = ['https://en.wikipedia.org/wiki/Scrapy',
                  'http://en.wikipedia.org/wiki/Python_%28programming_language%29']

    def parse(self, response):
        item = Article()
        title = response.xpath("//h1[@id='firstHeading']/text()").extract()[0]
        item['title'] = title
        body = response.xpath("//p").extract()
        body = ' '.join(body)
        item['body'] = body
        return item
