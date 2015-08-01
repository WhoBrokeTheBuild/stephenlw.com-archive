#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

WORKER_COUNT=3
WORKER_NAME=stephenlw

PROXY_NAME=hap-stephenlw
PROXY_CONF=haproxy.cfg

docker_build() {
    docker build -t $WORKER_NAME .
}

docker_stop() {
    printf "Killing..\n"
    for c in $(seq 1 $WORKER_COUNT); do
        docker kill $WORKER_NAME-$c
    done
    docker kill $PROXY_NAME
    printf "Done\n\n"
    
    printf "Removing..\n"
    for c in $(seq 1 $WORKER_COUNT); do
        docker rm $WORKER_NAME-$c
    done
    docker rm $PROXY_NAME
    printf "Done\n\n"
}

docker_run() {
    
    docker_stop
    
    printf "Starting..\n"
    
    for c in $(seq 1 $WORKER_COUNT); do
        docker_spawn_worker $WORKER_NAME-$c
    done
    
    printf "$PROXY_NAME "
    cmd="docker run -d -p 8080:8080"
        
    for c in $(seq 1 $WORKER_COUNT); do
        cmd="$cmd --link $WORKER_NAME-$c:$WORKER_NAME-$c"
    done
    
    cmd="$cmd -v $SCRIPTPATH/$PROXY_CONF:/usr/local/etc/haproxy/haproxy.cfg:ro"
    cmd="$cmd --name $PROXY_NAME haproxy:1.5.14"
    $cmd
    
    printf "Done\n\n"
}

docker_spawn_worker() {
    printf "$1 "
    docker run -d  \
        -v $SCRIPTPATH/static:/go/bin/static:ro \
        -v $SCRIPTPATH/templates:/go/bin/templates:ro \
        -v $SCRIPTPATH/content:/go/bin/content:ro \
        --name $1 $WORKER_NAME
}

build() {
    go build
}

install() {
    go install
}

run() {
    ./stephenlw.com
}

case $1 in 
    "docker-build" )
    
        docker_build
    
        ;;
    "docker-stop" )
    
        docker_stop
        
        ;;
    "docker-run" )
        
        docker_run

        ;;
    "build" )
    
        build
        
        ;;
    "install" )
    
        install
        
        ;;
    "run" )
    
        run
    
        ;;
esac