import sys
import urllib2

if len(sys.argv) == 1:
  print("Error usage. Need one argument keyword")
  sys.exit()

url = 'http://www.rcsb.org/pdb/rest/search'

queryText = """
<?xml version="1.0" encoding="UTF-8"?>
<orgPdbQuery>
<version>head</version>
<queryType>org.pdb.query.simple.AdvancedKeywordQuery</queryType>
<keywords> """ + sys.argv[1] + """ </keywords>
</orgPdbQuery>
"""


req = urllib2.Request(url, data=queryText)
f = urllib2.urlopen(req)
result = f.read()

if result:

    start = 0
    end = start + 4
    for i in range(0,result.count('\n')):
        print(result[start:end])
        start += 5
        end += 5

else:

    print("Failed to retrieve results") 
