# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class StackQuestion(scrapy.Item):
    type = scrapy.Field()
    id = scrapy.Field()
    title = scrapy.Field()
    author = scrapy.Field()
    date = scrapy.Field()
    body = scrapy.Field()
    answers = scrapy.Field()
    resolved = scrapy.Field()
    tags = scrapy.Field()
    upvotes = scrapy.Field()


class StackAnswer(scrapy.Item):
    type = scrapy.Field()
    id = scrapy.Field()
    qid = scrapy.Field()
    author = scrapy.Field()
    date = scrapy.Field()
    body = scrapy.Field()
    accepted = scrapy.Field()
    upvotes = scrapy.Field()
