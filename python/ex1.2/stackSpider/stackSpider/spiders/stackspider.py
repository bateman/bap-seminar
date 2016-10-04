# -*- coding: utf-8 -*-

# Define here the code for scraping content

from scrapy import Spider
from stackSpider.items import StackQuestion, StackAnswer
import re


class StackOverflowSpider(Spider):
    name = "stack"
    allowed_domains = ['stackoverflow.com']
    start_urls = ['http://stackoverflow.com/questions/3044580/multiprocessing-vs-threading-python']

    def parse(self, response):
        question = StackQuestion()

        question['type'] = 'question'
        id = re.search(r'^http:\/\/stackoverflow\.com\/questions\/(\d*)\/.*$', response.url)
        if id:
            question['id'] = id.group(1)
        else:
            question['id'] = response.url
        question['title'] = response.xpath("//h1/a[@class='question-hyperlink']/text()").extract()[0]
        question['author'] = \
            response.xpath("//td[@class='post-signature owner']/div/div[@class='user-details']/a/text()").extract()[0]
        question['date'] = \
            response.xpath("//td[@class='post-signature owner']//span[@class='relativetime']/@title").extract()[0]
        question['body'] = response.xpath("//div[@class='post-text']").extract()[0]
        question['answers'] = response.xpath("//span[@itemprop='answerCount']/text()").extract()[0]

        yield question

        answers_count = int(question['answers'])
        for i in range(1, answers_count + 1):
            answer = StackAnswer()

            answer['type'] = 'answer'
            answer['id'] = str(i)
            answer['qid'] = question['id']
            answer['author'] = \
                response.xpath("//td[@class='post-signature']/div/div[@class='user-details']/a/text()").extract()[i]
            answer['date'] = \
                response.xpath("//td[@class='post-signature']//span[@class='relativetime']/@title").extract()[i]
            answer['body'] = response.xpath("//div[@class='post-text']").extract()[i]

            yield answer
