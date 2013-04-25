import sys
import logging
#import urllib
from pyquery import PyQuery as pQuery
#from imp import reload


def lookup(*words):
  uri = "http://dict.baidu.com/s?wd=%(word)s"
  _word = ""

  logger.info(words)
  for word in words:
    _word += word + ' '
  _word = _word[:-1]
  word = {"word" : _word}
  url = uri % word
  logger.info(url)
  #doc = urllib.urlopen(url).read()
  doc =  pQuery(url=url)
  explain = doc('#en-simple-means>div').eq(0).find('p').text()
  print(explain)

def _getlog(level):
  logger =logging.getLogger(__name__)
  console = logging.StreamHandler()
  console.setFormatter(logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s'))
  logger.addHandler(console)
  logger.setLevel(level)
  return logger

logger = _getlog(logging.DEBUG)

if __name__ == "__main__":
  lookup(*sys.argv[1:])