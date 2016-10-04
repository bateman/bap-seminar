# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html

from bs4 import BeautifulSoup


class StackspiderPipeline(object):
    def process_item(self, item, spider):
        soup = BeautifulSoup(item['body'])
        item['body'] = soup.get_text().strip()
        return item
