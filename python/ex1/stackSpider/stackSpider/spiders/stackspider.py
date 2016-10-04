# -*- coding: utf-8 -*-

# Define here the code for scraping content

from scrapy import Spider
from stackSpider.items import StackQuestion


class StackOverflowSpider(Spider):
    name = "stack"
    allowed_domains = ['']
    start_urls = ['']

    def parse(self, response):
        question = StackQuestion()
        # ...
        return question

