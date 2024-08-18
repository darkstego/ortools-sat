require "./ortools-sat/model"

# Module to access ORTools::Sat from within Crystal
module ORTools::Sat
  VERSION = {{ `shards version "#{__DIR__}"`.stringify.chomp }}
end
