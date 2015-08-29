require 'sinatra'
require './bookmerge'

$stdout.sync = true

run Sinatra::Application
