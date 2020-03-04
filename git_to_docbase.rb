#!/usr/bin/env ruby
require 'json'
require 'pathname'
require 'irb'
require 'rubygems'
require 'pry-byebug'

def create_json(body, title)
  JSON[{
    body: body,
    tags: 'GitHubWiki',
    title: title
  }]
end

def post_wiki_to_docbase(json)

end

def title(entry)
  entry =~ /(.*)\.(textile|md)$/
  File.basename($1)
end

def entry_to_docbase(entry)
  puts entry.to_s

  body=IO.read(entry)

  binding.pry
  puts create_json(body, title(entry))
  exit
end


$token=ENV['DOC_BASE_TOKEN']

path = Dir.glob(ARGV[0] + '*')
path.entries.each do |e|
  unless e.to_s =~ /(.*)\.(textile|md)$/
    next
  end
  entry_to_docbase(e)
end



