# 01 install

## get java
~ apt-get install openjdk-6-jre-headless -y


## Get the latest stable archive
~ wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.zip

## Extract the archive
~ unzip elasticsearch-0.90.7.zip

## run !
~ cd elasticsearch-0.90.7

# This will run elasticsearch on foreground.
 ./bin/elasticsearch -f
[2013-12-13 15:45:25,187][INFO ][node                     ] [Bridge, George Washington] version[0.90.7], pid[37998], build[36897d0/2013-11-13T12:06:54Z]
[2013-12-13 15:45:25,189][INFO ][node                     ] [Bridge, George Washington] initializing ...
[2013-12-13 15:45:25,202][INFO ][plugins                  ] [Bridge, George Washington] loaded [], sites []
[2013-12-13 15:45:28,342][INFO ][node                     ] [Bridge, George Washington] initialized
[2013-12-13 15:45:28,342][INFO ][node                     ] [Bridge, George Washington] starting ...
[2013-12-13 15:45:28,491][INFO ][transport                ] [Bridge, George Washington] bound_address {inet[/0:0:0:0:0:0:0:0:9300]}, publish_address {inet[/192.168.1.12:9300]}
[2013-12-13 15:45:31,545][INFO ][cluster.service          ] [Bridge, George Washington] new_master [Bridge, George Washington][pKCdh1b_TP2TlurO1gm4_g][inet[/192.168.1.12:9300]], reason: zen-disco-join (elected_as_master)
[2013-12-13 15:45:31,577][INFO ][discovery                ] [Bridge, George Washington] elasticsearch/pKCdh1b_TP2TlurO1gm4_g
[2013-12-13 15:45:31,595][INFO ][http                     ] [Bridge, George Washington] bound_address {inet[/0:0:0:0:0:0:0:0:9200]}, publish_address {inet[/192.168.1.12:9200]}
[2013-12-13 15:45:31,596][INFO ][node                     ] [Bridge, George Washington] started
[2013-12-13 15:45:31,629][INFO ][gateway                  ] [Bridge, George Washington] recovered [0] indices into cluster_state
    
## Ping es in another term
~ curl http://127.0.0.1:9200
{
    "ok" : true,
    "status" : 200,
    "name" : "Gideon, Gregory",
    "version" : {
      "number" : "0.90.6",
      "build_hash" : "e2a24efdde0cb7cc1b2071ffbbd1fd874a6d8d6b",
      "build_timestamp" : "2013-11-04T13:44:16Z",
      "build_snapshot" : false,
      "lucene_version" : "4.5.1"
    },
    "tagline" : "You Know, for Search"
  }%


# 02 add documents

# put on workshop index and site type
~ curl -XPUT http://localhost:9200/workshop/site/1 -d '
{
  "url": "http://www.elasticsearch.org",
  "title": "Open Source Distributed Real Time Search & Analytics",
  "description": "Elasticsearch is a powerful open source search and analytics engine that makes data easy to explore.",
  "tags": ["Open Source", "elasticsearch", "Distributed"]
}'
{"ok":true,"_index":"workshop","_type":"sites","_id":"1","_version":1}%

# retreive the document
~ curl -XGET http://localhost:9200/workshop/site/1
{"_index":"workshop","_type":"site","_id":"1","_version":2,"exists":true, "_source" :
{
  "url": "http://www.elasticsearch.org",
  "title": "Open Source Distributed Real Time Search & Analytics",
  "description": "Elasticsearch is a powerful open source search and analytics engine that makes data easy to explore.",
  "tags": ["Open Source", "elasticsearch", "Distributed"]
}}%

# add more documents
~ curl -XPUT http://localhost:9200/workshop/site/2 -d '
{
  "url": "http://www.mathieu-elie.net",
  "title": "Mathieu ELIE  Freelance - Full Stack Data Engineer, Data Visualization",
  "description": "Freelance Consultant in Bordeaux, System &amp; Software Architect. Love dataviz, redis, elasticsearch, architecture scalability recipes and playing with data.",
  tags: ["elasticsearch", "Data Visualization"]
}'

~ curl -XPUT http://localhost:9200/workshop/site/3 -d '
{
  "url": "http://www.giroll.org",
  "title": "Collectif Giroll - Gironde Logiciels Libres",
  "description": "Giroll, collectif basé à Bordeaux, réunis autour des Logiciels et des Cultures libres. Ateliers tous les mardis de 18h30 à 20h30 et organisation d''Install Party Linux tous les six",
  tags: ["Open Source", "Collectif"]
}'

# now search !
# will send back to us all documents
~ curl  'http://localhost:9200/workshop/_search?pretty=true'
{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "failed" : 0
  },
  "hits" : {
    "total" : 3,
    "max_score" : 1.0,
    "hits" : [ {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "1",
      "_score" : 1.0, "_source" :
{
  "url": "http://www.elasticsearch.org",
  "title": "Open Source Distributed Real Time Search & Analytics",
  "description": "Elasticsearch is a powerful open source search and analytics engine that makes data easy to explore.",
  "tags": ["Open Source", "elasticsearch", "Distributed"]
}
    }, {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "3",
      "_score" : 1.0, "_source" :
{
  "url": "http://www.giroll.org",
  "title": "Collectif Giroll - Gironde Logiciels Libres",
  "description": "Giroll, collectif basé à Bordeaux, réunis autour des Logiciels et des Cultures libres. Ateliers tous les mardis de 18h30 à 20h30 et organisation dInstall Party Linux tous les six",
  tags: ["Open Source", "Collectif"]
}
    }, {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "2",
      "_score" : 1.0, "_source" :
{
  "url": "http://www.mathieu-elie.net",
  "title": "Mathieu ELIE  Freelance - Full Stack Data Engineer, Data Visualization",
  "description": "Freelance Consultant in Bordeaux, System &amp; Software Architect. Love dataviz, redis, elasticsearch, architecture scalability recipes and playing with data.",
  tags: ["elasticsearch", "Data Visualization"]
}
    } ]
  }
}

# ok great, but now i want to search for text !

# step 1 : pass query as a request body
curl -XGET 'http://localhost:9200/workshop/site/_search?pretty=true' -d '{
    "query" : {
        "match_all" : { }
    }
}'
{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "failed" : 0
  },
  "hits" : {
    "total" : 3,
    "max_score" : 1.0,
    "hits" : [ {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "1",
      "_score" : 1.0, "_source" :
{
  "url": "http://www.elasticsearch.org",
  "title": "Open Source Distributed Real Time Search & Analytics",
  "description": "Elasticsearch is a powerful open source search and analytics engine that makes data easy to explore.",
  "tags": ["Open Source", "elasticsearch", "Distributed"]
}
    }, {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "3",
      "_score" : 1.0, "_source" :
{
  "url": "http://www.giroll.org",
  "title": "Collectif Giroll - Gironde Logiciels Libres",
  "description": "Giroll, collectif basé à Bordeaux, réunis autour des Logiciels et des Cultures libres. Ateliers tous les mardis de 18h30 à 20h30 et organisation dInstall Party Linux tous les six",
  tags: ["Open Source", "Collectif"]
}
    }, {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "2",
      "_score" : 1.0, "_source" :
{
  "url": "http://www.mathieu-elie.net",
  "title": "Mathieu ELIE  Freelance - Full Stack Data Engineer, Data Visualization",
  "description": "Freelance Consultant in Bordeaux, System &amp; Software Architect. Love dataviz, redis, elasticsearch, architecture scalability recipes and playing with data.",
  tags: ["elasticsearch", "Data Visualization"]
}
    } ]
  }
}

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
{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "failed" : 0
  },
  "hits" : {
    "total" : 2,
    "max_score" : 0.081366636,
    "hits" : [ {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "1",
      "_score" : 0.081366636, "_source" :
{
  "url": "http://www.elasticsearch.org",
  "title": "Open Source Distributed Real Time Search & Analytics",
  "description": "Elasticsearch is a powerful open source search and analytics engine that makes data easy to explore.",
  "tags": ["Open Source", "elasticsearch", "Distributed"]
}
    }, {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "2",
      "_score" : 0.06780553, "_source" :
{
  "url": "http://www.mathieu-elie.net",
  "title": "Mathieu ELIE  Freelance - Full Stack Data Engineer, Data Visualization",
  "description": "Freelance Consultant in Bordeaux, System &amp; Software Architect. Love dataviz, redis, elasticsearch, architecture scalability recipes and playing with data.",
  tags: ["elasticsearch", "Data Visualization"]
}
    } ]
  }
}

# result is a a quiet verbose lets get only title and tags fields
curl -XPOST 'http://localhost:9200/workshop/site/_search?pretty=true' -d '{
  "fields" : ["title", "tags"],
  "query" : {

        "query_string" : {
            "query" : "elasticsearch"
        }
    }
}'
{
  "took" : 6,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "failed" : 0
  },
  "hits" : {
    "total" : 2,
    "max_score" : 0.081366636,
    "hits" : [ {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "1",
      "_score" : 0.081366636,
      "fields" : {
        "tags" : [ "Open Source", "elasticsearch", "Distributed" ],
        "title" : "Open Source Distributed Real Time Search & Analytics"
      }
    }, {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "2",
      "_score" : 0.06780553,
      "fields" : {
        "tags" : [ "elasticsearch", "Data Visualization" ],
        "title" : "Mathieu ELIE  Freelance - Full Stack Data Engineer, Data Visualization"
      }
    } ]
  }
}

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
{
  "took" : 2,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "failed" : 0
  },
  "hits" : {
    "total" : 2,
    "max_score" : 0.081366636,
    "hits" : [ {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "1",
      "_score" : 0.081366636,
      "fields" : {
        "tags" : [ "Open Source", "elasticsearch", "Distributed" ],
        "title" : "Open Source Distributed Real Time Search & Analytics"
      }
    }, {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "2",
      "_score" : 0.06780553,
      "fields" : {
        "tags" : [ "elasticsearch", "Data Visualization" ],
        "title" : "Mathieu ELIE  Freelance - Full Stack Data Engineer, Data Visualization"
      }
    } ]
  },
  "facets" : {
    "tags" : {
      "_type" : "terms",
      "missing" : 0,
      "total" : 7,
      "other" : 0,
      "terms" : [ {
        "term" : "elasticsearch",
        "count" : 2
      }, {
        "term" : "visualization",
        "count" : 1
      }, {
        "term" : "source",
        "count" : 1
      }, {
        "term" : "open",
        "count" : 1
      }, {
        "term" : "distributed",
        "count" : 1
      }, {
        "term" : "data",
        "count" : 1
      } ]
    }
  }
}


# hey ! see "Open Source" !  it is lower cased and exploded in multiple tokens !
# this is done by the defautl mapping and analyzer
curl  'http://localhost:9200/workshop/site/_mapping?pretty=true' 
{
  "site" : {
    "properties" : {
      "description" : {
        "type" : "string"
      },
      "tags" : {
        "type" : "string"
      },
      "title" : {
        "type" : "string"
      },
      "url" : {
        "type" : "string"
      }
    }
  }
}

# tags is a type of string and we have a default analyzer
# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/analysis-standard-analyzer.html
# An analyzer of type standard is built using the Standard Tokenizer with the Standard Token Filter, Lower Case Token Filter, and Stop Token Filter.

curl -XGET 'localhost:9200/workshop/_analyze?pretty=true' -d 'Open Source'
{
  "tokens" : [ {
    "token" : "open",
    "start_offset" : 0,
    "end_offset" : 4,
    "type" : "<ALPHANUM>",
    "position" : 1
  }, {
    "token" : "source",
    "start_offset" : 5,
    "end_offset" : 11,
    "type" : "<ALPHANUM>",
    "position" : 2
  } ]
}

# what about keyword analyzer ?
# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/analysis-keyword-analyzer.html
curl -XGET 'localhost:9200/workshop/_analyze?analyzer=keyword&pretty=true' -d 'Open Source'
{
  "tokens" : [ {
    "token" : "Open Source",
    "start_offset" : 0,
    "end_offset" : 11,
    "type" : "word",
    "position" : 1
  } ]
}

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
{
  "error" : "MergeMappingException[Merge failed with failures {[mapper [tags] has different index_analyzer]}]",
  "status" : 400
}

# oops ! we drop..
curl  -XDELETE 'http://localhost:9200/workshop/'
{"ok":true,"acknowledged":true}%

# index should exists if we want to put mapping..
curl  -XPUT 'http://localhost:9200/workshop/'
{"ok":true,"acknowledged":true}%

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
{"ok":true,"acknowledged":true}%

# test on the field analysis 
 ~  curl -XGET 'localhost:9200/workshop/_analyze?pretty=true&field=site.tags' -d 'Open Source'
{
  "tokens" : [ {
    "token" : "Open Source",
    "start_offset" : 0,
    "end_offset" : 11,
    "type" : "word",
    "position" : 1
  } ]
}

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
{
  "took" : 6,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "failed" : 0
  },
  "hits" : {
    "total" : 2,
    "max_score" : 0.081366636,
    "hits" : [ {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "1",
      "_score" : 0.081366636,
      "fields" : {
        "tags" : [ "Open Source", "elasticsearch", "Distributed" ],
        "title" : "Open Source Distributed Real Time Search & Analytics"
      }
    }, {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "2",
      "_score" : 0.06780553,
      "fields" : {
        "tags" : [ "elasticsearch", "Data Visualization" ],
        "title" : "Mathieu ELIE  Freelance - Full Stack Data Engineer, Data Visualization"
      }
    } ]
  },
  "facets" : {
    "tags" : {
      "_type" : "terms",
      "missing" : 0,
      "total" : 5,
      "other" : 0,
      "terms" : [ {
        "term" : "elasticsearch",
        "count" : 2
      }, {
        "term" : "Open Source",
        "count" : 1
      }, {
        "term" : "Distributed",
        "count" : 1
      }, {
        "term" : "Data Visualization",
        "count" : 1
      } ]
    }
  }
}

# cool ! our facets contains whole tags ! great jobs !!

# now filter !
curl -XGET 'http://localhost:9200/workshop/site/_search?pretty=true' -d '{
    "query" : {
        "match_all" : { }
    }
}'
{
  "took" : 2,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "failed" : 0
  },
  "hits" : {
    "total" : 3,
    "max_score" : 1.0,
    "hits" : [ {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "1",
      "_score" : 1.0, "_source" :
{
  "url": "http://www.elasticsearch.org",
  "title": "Open Source Distributed Real Time Search & Analytics",
  "description": "Elasticsearch is a powerful open source search and analytics engine that makes data easy to explore.",
  "tags": ["Open Source", "elasticsearch", "Distributed"]
}
    }, {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "3",
      "_score" : 1.0, "_source" :
{
  "url": "http://www.giroll.org",
  "title": "Collectif Giroll - Gironde Logiciels Libres",
  "description": "Giroll, collectif basé à Bordeaux, réunis autour des Logiciels et des Cultures libres. Ateliers tous les mardis de 18h30 à 20h30 et organisation dInstall Party Linux tous les six",
  tags: ["Open Source", "Collectif"]
}
    }, {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "2",
      "_score" : 1.0, "_source" :
{
  "url": "http://www.mathieu-elie.net",
  "title": "Mathieu ELIE  Freelance - Full Stack Data Engineer, Data Visualization",
  "description": "Freelance Consultant in Bordeaux, System &amp; Software Architect. Love dataviz, redis, elasticsearch, architecture scalability recipes and playing with data.",
  tags: ["elasticsearch", "Data Visualization"]
}
    } ]
  }
}

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
{
  "took" : 2,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "failed" : 0
  },
  "hits" : {
    "total" : 2,
    "max_score" : 1.0,
    "hits" : [ {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "1",
      "_score" : 1.0, "_source" :
{
  "url": "http://www.elasticsearch.org",
  "title": "Open Source Distributed Real Time Search & Analytics",
  "description": "Elasticsearch is a powerful open source search and analytics engine that makes data easy to explore.",
  "tags": ["Open Source", "elasticsearch", "Distributed"]
}
    }, {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "3",
      "_score" : 1.0, "_source" :
{
  "url": "http://www.giroll.org",
  "title": "Collectif Giroll - Gironde Logiciels Libres",
  "description": "Giroll, collectif basé à Bordeaux, réunis autour des Logiciels et des Cultures libres. Ateliers tous les mardis de 18h30 à 20h30 et organisation dInstall Party Linux tous les six",
  tags: ["Open Source", "Collectif"]
}
    } ]
  }
}

curl -XGET 'http://localhost:9200/workshop/site/_search?pretty=true' -d '{
    "query" : {
        "match_all" : { }
    },
    "filter" : {
            "term" : { "tags" : "Collectif"}
    }
}'
{
  "took" : 2,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 1.0,
    "hits" : [ {
      "_index" : "workshop",
      "_type" : "site",
      "_id" : "3",
      "_score" : 1.0, "_source" :
{
  "url": "http://www.giroll.org",
  "title": "Collectif Giroll - Gironde Logiciels Libres",
  "description": "Giroll, collectif basé à Bordeaux, réunis autour des Logiciels et des Cultures libres. Ateliers tous les mardis de 18h30 à 20h30 et organisation dInstall Party Linux tous les six",
  tags: ["Open Source", "Collectif"]
}
    } ]
  }
}

# 03 define mappings

# 04 common requests

# 05 analyzers testings

# 06 the way for rtfm












