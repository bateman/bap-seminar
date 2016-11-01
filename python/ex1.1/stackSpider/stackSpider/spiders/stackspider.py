# -*- coding: utf-8 -*-

# Define here the code for scraping content

from scrapy import Spider
from stackSpider.items import StackQuestion
import re


class StackOverflowSpider(Spider):
    name = "stack"
    allowed_domains = ['stackoverflow.com']
    start_urls = ['http://stackoverflow.com/questions/3044580/multiprocessing-vs-threading-python']

    def parse(self, response):
        question = StackQuestion()

        id = re.search(r'^http:\/\/stackoverflow\.com\/questions\/(\d*)\/.*$', response.url)
        if id:
            question['id'] = id.group(1)
        else:
            question['id'] = 're error'

        question['title'] = response.xpath("//h1/a[@class='question-hyperlink']/text()").extract()[0]
        question['author'] = response.xpath("//td/div/div[@class='user-details']/a/text()").extract()[0]
        question['date'] = response.xpath("//td//span[@class='relativetime']/@title").extract()[0]
        question['body'] = response.xpath("//div[@class='post-text']").extract()[0]
        question['answers'] = response.xpath("//span[@itemprop='answerCount']/text()").extract()[0]

        return question
