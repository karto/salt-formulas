#!/bin/sh

#
# PROVIDE: kafka
# REQUIRE: LOGIN
# KEYWORD: shutdown
#
# Add the following line to /etc/rc.conf to enable kafka:
#
# kafka_enable="YES"

. /etc/rc.subr

name=kafka
rcvar=kafka_enable

load_rc_config $name
: ${kafka_enable:="NO"}
: ${kafka_logdir:=/var/log/kafka}
: ${kafka_user:=kafka}
: ${kafka_group:=kafka}

command="{{ kafka.lookup.base_dir }}/bin/kafka-server-start.sh"
command_args="-daemon {{ kafka.lookup.config_file }}"
#procname="kafka.Kafka"
#command_interpreter="java"
kafka_chdir="{{ kafka.lookup.base_dir }}"
kafka_env="CLASSPATH=/usr/local/share/java/classes/mx4j-tools.jar"

start_precmd="${name}_precmd"
stop_cmd="{{ kafka.lookup.base_dir }}/bin/kafka-server-stop.sh"



kafka_precmd()
{
  /usr/bin/install -d -o ${kafka_user} -g ${kafka_group} -m 750 /var/log/kafka
  /usr/bin/install -d -o ${kafka_user} -g ${kafka_group} -m 750 /var/db/kafka
}
export LOG_DIR="${kafka_logdir}"
export JMX_PORT=${JMX_PORT:-2999}
export PATH="${PATH}:/usr/local/bin"
export KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:{{ kafka.lookup.log4j_file }}"
#KAFKA_HEAP_OPTS="-Xmx256M"
run_rc_command "$1"