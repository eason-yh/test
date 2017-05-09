#!/bin/bash
#Redis-3.0
#InstallationPath=/usr/local/
#ConfigPath=/etc/redis
#DownloadUrl=http://download.redis.io/releases/redis-3.0.7.tar.gz
Installdir=/usr/local/
Workdir=/usr/local/redis
if [ -f redis-3.0.7.tar.gz ];then
    echo "-----------------------------"
    echo "Redispackage is existence"
    echo "Install start ..............."
    echo "-----------------------------"
    tar xf redis-3.0.7.tar.gz -C $Installdir && cd $Installdir && mv $Installdir/redis-3.0.7 $Installdir/redis && cd $Workdir/ && make >/dev/null 2>&1 && cd $Workdir/src && make install >/dev/null 2>&1
    if [ $? -ne 0 ];then
       echo "Make Error"
    else
        echo "-----------------------------"
        echo "Install           Successful!"
        echo "-----------------------------"
    fi
    if [ -f $Workdir/redis.conf ];then
        if [ ! -d /var/log/redis ];then
            echo "Logfile Dir Non-existent"
            echo "Create Dir.............."
            mkdir /var/log/redis
            echo "-----------------------------"
            echo "Configuration Configfile"
            echo "-----------------------------"
            sed -i 's#daemonize no#daemonize yes#g' $Workdir/redis.conf
            sed -i 's#dir ./#dir /usr/local/#g' $Workdir/redis.conf
            sed -i 's#appendonly no#appendonly yes#g' $Workdir/redis.conf
            sed -i 's#logfile ""#logfile "/var/log/redis/redis.log"#g' $Workdir/redis.conf
            echo "-----------------------------"
            echo "Start Rdis .................."
            echo "-----------------------------"
            $Workdir/src/redis-server $Workdir/redis.conf
            Process=`ps -ef|grep redis|grep -v "grep redis"|wc -l`
            if [ $Process -ne 0 ];then
                echo "-----------------------------"
                echo "Start     Rdis    Successful!"
                echo "-----------------------------"
            else
                echo "-----------------------------"
                echo "Start     Rdis    Fali     !"
                echo "-----------------------------"    
            fi
        else
            echo "Logfile Dir existence"
        fi
    else
        echo "Redisconfig Non-existent"
    fi
else
    echo "Redispackage is not existence"
    echo "DownloadUrl:http://download.redis.io/releases/redis-3.0.7.tar.gz"
    echo "wget http://download.redis.io/releases/redis-3.0.7.tar.gz"
fi
