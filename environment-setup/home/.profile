# ALIASES

# standard aliases
alias ll='ls -las'
alias ..='cd ..'

# git
alias gstat='git status'
alias glog='git log'
alias gpull='git pull --rebase'
alias gpush='git push'

# Redis
alias redisstart='sudo launchctl start io.redis.redis-server'
alias redisstop='sudo launchctl stop io.redis.redis-server'

# EngineYard servers
# navy panda
alias ssh_navypanda='ssh deploy@navypanda'

# staging
alias ssh_staging='ssh deploy@staging'

# production
alias ssh_prod_app_master='ssh deploy@prod-app-master'
alias ssh_prod_app_00='ssh deploy@prod-app-00'
alias ssh_prod_app_01='ssh deploy@prod-app-01'
alias ssh_prod_db_master='ssh deploy@prod-db-master'
alias ssh_prod_db_slave='ssh deploy@prod-db-slave'
alias ssh_prod_utility='ssh deploy@prod-utility'
alias ssh_prod_utility_es='ssh deploy@prod-utility-es'

# EC2 servers
alias ec2ssh='ssh -o "ServerAliveInterval 10" -o "StrictHostKeyChecking false" -i ~/.ec2/josh.pem'

# PATHS
export DEV_HOME=~/opt
export USER_SBIN=~/.sbin

# Java
export JAVA_HOME=/Library/Java/Home

# Hadoop
export HADOOP_BASE=$DEV_HOME/hadoop

export HADOOP_HOME_=$HADOOP_BASE/hadoop
export PIG_HOME=$HADOOP_BASE/pig
export MAHOUT_HOME=$HADOOP_BASE/mahout

# AWS
export EC2_PRIVATE_KEY=~/.ec2/pk-josh.pem
export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"
export EMR_HOME=~/opt/aws/elastic-mapreduce-ruby

# export
export PATH=$PATH:$USER_SBIN:$PIG_HOME/bin:$MAHOUT_HOME/bin:$EMR_HOME

