#!/bin/sh

function app
{
    echo "running in [app] mode"
    bundle exec rails db:create
    bundle exec rails db:migrate && bundle exec rails db:seed
    bundle exec puma -C config/puma.rb
}

function worker
{
    echo "running in [worker] mode"
    bundle exec sidekiq -C config/sidekiq.yml
}

function usage
{
    echo "usage: entrypoints.sh [app|worker]"
}

if [ "$1" != "" ]; then
    case $1 in
        app | application )     app
                                ;;
        worker )                worker
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
else
    echo "Please specify a param:"
    usage
fi
