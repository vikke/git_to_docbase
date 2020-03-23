#!/usr/bin/env ruby
require 'json'
require 'pathname'
require 'net/http'
require 'rubygems'
require 'pry-byebug'


def create_json(body, title)
  JSON[{
    body: body,
    tags: ['GitHubWiki'],
    title: title,
    scope: 'group',
    groups: [16821]
  }]
end

def post_wiki_to_docbase(json)
  uri = URI.parse('https://api.docbase.io/teams/lsd-inc/posts')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === "https"
  headers = {
    'X-DocBaseToken' => $token,
    'Content-Type' => 'application/json'
  }

  response = http.post(uri.path, json, headers)

  puts JSON.parse(json)["title"]
  puts response.code

  sleep 3600 / 300 + 1
end

def title(entry)
  entry =~ /(.*)\.(textile|md)$/
  File.basename($1)
end

def entry_to_docbase(entry)
  body=IO.read(entry)
  post_wiki_to_docbase(create_json(body, title(entry)))
end


$token=ENV['DOC_BASE_TOKEN']

path = Dir.glob(ARGV[0] + '*')
path.entries.each do |e|
  unless e.to_s =~ /(.*)\.(textile|md)$/
    next
  end
  entry_to_docbase(e)
end



