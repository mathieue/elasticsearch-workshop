# 01 install

## get java
apt-get install openjdk-6-jre-headless -y

## Get the latest stable archive
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.zip

## Extract the archive
unzip elasticsearch-0.90.7.zip

## run !
cd elasticsearch-0.90.7

# This will run elasticsearch on foreground.
 ./bin/elasticsearch -f

    
## Ping es in another term
curl http://127.0.0.1:9200


# 02 add documents

# put on workshop index and site type
curl -XPUT http://localhost:9200/workshop/site/1 -d '
{
  "url": "http://www.elasticsearch.org",
  "title": "Open Source Distributed Real Time Search & Analytics",
  "description": "Elasticsearch is a powerful open source search and analytics engine that makes data easy to explore.",
  "tags": ["Open Source", "elasticsearch", "Distributed"]
}'


# retreive the document
curl -XGET http://localhost:9200/workshop/site/1


# add more documents
curl -XPUT http://localhost:9200/workshop/site/2 -d '
{
  "url": "http://www.mathieu-elie.net",
  "title": "Mathieu ELIE  Freelance - Full Stack Data Engineer, Data Visualization",
  "description": "Freelance Consultant in Bordeaux, System &amp; Software Architect. Love dataviz, redis, elasticsearch, architecture scalability recipes and playing with data.",
  tags: ["elasticsearch", "Data Visualization"]
}'

curl -XPUT http://localhost:9200/workshop/site/3 -d '
{
  "url": "http://www.giroll.org",
  "title": "Collectif Giroll - Gironde Logiciels Libres",
  "description": "Giroll, collectif basé à Bordeaux, réunis autour des Logiciels et des Cultures libres. Ateliers tous les mardis de 18h30 à 20h30 et organisation d''Install Party Linux tous les six",
  tags: ["Open Source", "Collectif"]
}'

# now search !
# will send back to us all documents
curl  'http://localhost:9200/workshop/_search?pretty=true'


# ok great, but now i want to search for text !

# step 1 : pass query as a request body
curl -XPOST 'http://localhost:9200/workshop/site/_search?pretty=true' -d '{
    "query" : {
        "match_all" : { }
    }
}'


# It returns all documents
# because we use the match all query
http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-match-all-query.html

# match_all query is part of the queries dsl 
http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-queries.html

# so lets use the query_strig query dsl
curl -XPOST 'http://localhost:9200/workshop/site/_search?pretty=true' -d '{
  "query" : {
        "query_string" : {
            "query" : "elasticsearch"
        }
    }
}'


# result is a a quiet verbose lets get only title and tags fields
curl -XPOST 'http://localhost:9200/workshop/site/_search?pretty=true' -d '{
  "fields" : ["title", "tags"],
  "query" : {

        "query_string" : {
            "query" : "elasticsearch"
        }
    }
}'


# lets go for facets on tags !!
# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-facets.html
curl -XPOST 'http://localhost:9200/workshop/site/_search?pretty=true' -d '{
  "fields" : ["title", "tags"],
  "query" : {

        "query_string" : {
            "query" : "elasticsearch"
        }
    },
    "facets" : {
      "tags" : { "terms" : {"field" : "tags"} }
    }
}'

# hey ! see "Open Source" !  it is lower cased and exploded in multiple tokens !
# this is done by the defautl mapping and analyzer
curl  'http://localhost:9200/workshop/site/_mapping?pretty=true' 

# tags is a type of string and we have a default analyzer
# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/analysis-standard-analyzer.html
# An analyzer of type standard is built using the Standard Tokenizer with the Standard Token Filter, Lower Case Token Filter, and Stop Token Filter.

curl -XGET 'localhost:9200/workshop/_analyze?pretty=true' -d 'Open Source'

# what about keyword analyzer ?
# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/analysis-keyword-analyzer.html
curl -XGET 'localhost:9200/workshop/_analyze?analyzer=keyword&pretty=true' -d 'Open Source'

# got it ! now how to apply this to our tags field ?
curl  'http://localhost:9200/workshop/site/_mapping?pretty=true' -d '
{
    "site" : {
        "properties" : {
            "url" : {"type" : "string"},
            "title" : {"type" : "string"},
            "description" : {"type" : "string"},
            "tags" : {"type" : "string", "analyzer": "keyword" }
        }
    }
}
'

# oops ! we drop..
curl  -XDELETE 'http://localhost:9200/workshop/'

# index should exists if we want to put mapping..
curl  -XPUT 'http://localhost:9200/workshop/'

curl  'http://localhost:9200/workshop/site/_mapping?pretty=true' -d '
{
    "site" : {
        "properties" : {
            "url" : {"type" : "string"},
            "title" : {"type" : "string"},
            "description" : {"type" : "string"},
            "tags" : {"type" : "string", "analyzer": "keyword" }
        }
    }
}
'

# test on the field analysis 
  curl -XGET 'localhost:9200/workshop/_analyze?pretty=true&field=site.tags' -d 'Open Source'

# congrats ! 
# lets push data again
curl -XPUT http://localhost:9200/workshop/site/1 -d '
{
  "url": "http://www.elasticsearch.org",
  "title": "Open Source Distributed Real Time Search & Analytics",
  "description": "Elasticsearch is a powerful open source search and analytics engine that makes data easy to explore.",
  "tags": ["Open Source", "elasticsearch", "Distributed"]
}'


curl -XPUT http://localhost:9200/workshop/site/2 -d '
{
  "url": "http://www.mathieu-elie.net",
  "title": "Mathieu ELIE  Freelance - Full Stack Data Engineer, Data Visualization",
  "description": "Freelance Consultant in Bordeaux, System &amp; Software Architect. Love dataviz, redis, elasticsearch, architecture scalability recipes and playing with data.",
  tags: ["elasticsearch", "Data Visualization"]
}'

curl -XPUT http://localhost:9200/workshop/site/3 -d '
{
  "url": "http://www.giroll.org",
  "title": "Collectif Giroll - Gironde Logiciels Libres",
  "description": "Giroll, collectif basé à Bordeaux, réunis autour des Logiciels et des Cultures libres. Ateliers tous les mardis de 18h30 à 20h30 et organisation d''Install Party Linux tous les six",
  tags: ["Open Source", "Collectif"]
}'

# faceting ok ???
curl -XPOST 'http://localhost:9200/workshop/site/_search?pretty=true' -d '{
  "fields" : ["title", "tags"],
  "query" : {
        "query_string" : {
            "query" : "elasticsearch"
        }
    },
    "facets" : {
      "tags" : { "terms" : {"field" : "tags"} }
    }
}'

# cool ! our facets contains whole tags ! great jobs !!

# now filter !
curl -XGET 'http://localhost:9200/workshop/site/_search?pretty=true' -d '{
    "query" : {
        "match_all" : { }
    }
}'


# if want only docs with "Open Source" tag
# we use filters
# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-filters.html
# and term filter

curl -XGET 'http://localhost:9200/workshop/site/_search?pretty=true' -d '{
    "query" : {
        "match_all" : { }
    },
    "filter" : {
            "term" : { "tags" : "Open Source"}
    }
}'

curl -XGET 'http://localhost:9200/workshop/site/_search?pretty=true' -d '{
    "query" : {
        "match_all" : { }
    },
    "filter" : {
            "term" : { "tags" : "Collectif"}
    }
}'