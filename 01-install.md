Install elasticsearch
-------------------------

## Get java

You should have java installed. This is the only dependency you need to run es !

    apt-get install openjdk-6-jre-headless -y

## Get the latest stable archive

  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.zip

## Extract the archive

  unzip elasticsearch-0.90.7.zip

## run !


  cd elasticsearch-0.90.7

This will run elasticsearch on foreground.

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

  ➜  ~  curl http://127.0.0.1:9200
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

Someone replied !