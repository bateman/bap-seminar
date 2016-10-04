# -*- coding: utf-8 -*-

# Define here the code for scraping content

from scrapy import Spider
from stackSpider.items import StackQuestionItem, StackAnswerItem


class StackOverflowSpider(Spider):
    name = "article"
    allowed_domains = ['']
    start_urls = ['']

    def parse(self, response):
        question = StackQuestionItem()
        # ...
        yield question
        answer = StackAnswerItem()
        #...
        yield answer
