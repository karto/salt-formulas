#! /bin/sh


export PATH="/usr/home/elasticsearch/.local/bin:$PATH"

#curatorcmd="curator --dry-run"
curatorcmd="curator"


filter () {
  # Usage
  if [ $# -eq 2 ]; then
    echo --prefix "$1" --older-than $2 --time-unit days --timestring "%Y.%m.%d" 
  elif [ $# -eq 3 ]; then
    echo --prefix "$1" --newer-than $2 --older-than $3 --time-unit days --timestring "%Y.%m.%d" 
  fi
}

maintain_index () {
  prefix="${1}-"
  agelimit=$2
  deleteolder=$3
  closeolder=$4
  bloomolder=$5
  optimizeolder=$5
  echo "$(date "+%Y-%m-%d %H:%M:%S")     NOTICE    Maintaince: curator delete indices $(filter "$prefix" $agelimit $deleteolder) ***"
  $curatorcmd delete indices $(filter "$prefix" $agelimit $deleteolder)
  echo "$(date "+%Y-%m-%d %H:%M:%S")     NOTICE    Maintaince: curator close indices $(filter "$prefix" $deleteolder $closeolder) ***"
  $curatorcmd close indices $(filter "$prefix" $deleteolder $closeolder)
  echo "$(date "+%Y-%m-%d %H:%M:%S")     NOTICE    Maintaince: curator bloom indices $(filter "$prefix" $closeolder $bloomolder) ***"
  $curatorcmd bloom indices $(filter "$prefix" $closeolder $bloomolder)
  echo "$(date "+%Y-%m-%d %H:%M:%S")     NOTICE    Maintaince: curator optimize indices $(filter "$prefix" $closeolder $optimizeolder) ***"
  $curatorcmd optimize indices $(filter "$prefix" $closeolder $optimizeolder)
}

maintain_index "elf-logstash" 180 90 60 2 2
maintain_index "jslog-logstash" 180 90 60 2 2
maintain_index "logstash" 180 90 60 2 2
maintain_index "logstash-cmcluster" 180 90 60 2 2
maintain_index "logstash-dmesg" 180 90 60 2 2
maintain_index "logstash-elf" 180 90 60 2 2
maintain_index "logstash-kafka" 180 90 60 2 2
maintain_index "logstash-kafka_gc" 180 90 60 2 2
maintain_index "logstash-salt" 180 90 60 2 2
maintain_index "logstash-syslog" 180 90 60 2 2
maintain_index "logstash-zookeeper" 180 90 60 2 2

