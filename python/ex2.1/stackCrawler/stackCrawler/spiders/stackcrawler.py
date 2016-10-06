# -*- coding: utf-8 -*-
import scrapy
from scrapy.linkextractors import LinkExtractor
from scrapy.spiders import CrawlSpider, Rule
from stackCrawler.items import *


class StackcrawlerSpider(CrawlSpider):
    name = 'stackcrawler'
    allowed_domains = ['stackoverflow.com']
    start_urls = ['http://www.stackoverflow.com/',
                  'http://stackoverflow.com/questions/3044580/multiprocessing-vs-threading-python']

    rules = (
        Rule(LinkExtractor(allow=r'Items/'), callback='parse_item', follow=True),
    )

    def parse_item(self, response):
        i = {}
        # i['domain_id'] = response.xpath('//input[@id="sid"]/@value').extract()
        # i['name'] = response.xpath('//div[@id="name"]').extract()
        # i['description'] = response.xpath('//div[@id="description"]').extract()
        return i

    def parse(self, response):
        question = StackQuestion()
        question['type'] = 'question'
        question['id'] = response.xpath(("//div[@id='question']/@data-questionid")).extract()[0]
        question['title'] = response.xpath("//h1/a[@class='question-hyperlink']/text()").extract()[0]
        question['author'] = \
            response.xpath("//td[@class='post-signature owner']/div/div[@class='user-details']/a/text()").extract()[0]
        question['date'] = \
            response.xpath("//td[@class='post-signature owner']//span[@class='relativetime']/@title").extract()[0]
        question['body'] = response.xpath("//div[@class='post-text']").extract()[0]
        question['answers'] = response.xpath("//span[@itemprop='answerCount']/text()").extract()[0]
        question['resolved'] = ''
        taglist = response.xpath("//div[@class='post-taglist']/a/text()").extract()
        question['tags'] = ', '.join(taglist)
        question['upvotes'] = response.xpath("//div[@class='vote']/span[@class='vote-count-post ']/text()").extract()[0]

        answers_count = int(question['answers'])
        for i in range(1, answers_count + 1):
            answer = StackAnswer()
            answer['type'] = 'answer'
            answer['id'] = response.xpath("//input[@name='_id_']/@value").extract()[i]
            answer['qid'] = question['id']
            answer['author'] = \
                response.xpath("//td/div/div[@class='user-details']/a/text()").extract()[i]
            answer['date'] = \
                response.xpath("//td//span[@class='relativetime']/@title").extract()[i]
            answer['body'] = response.xpath("//div[@class='post-text']").extract()[i]
            try:
                answer['accepted'] = \
                response.xpath("//div[@id='answers']//div[@id='answer-{0}']/@itemprop".format(answer['id'])).extract()[
                    0]
                if answer['accepted'] == 'acceptedAnswer':
                    question['resolved'] = answer['id']
            except IndexError:
                answer['accepted'] = ''
            answer['upvotes'] = \
                response.xpath("//div[@class='vote']/span[@class='vote-count-post ']/text()").extract()[i]
            yield answer

        yield question
