#!/usr/bin/env ruby
require 'json'
require 'pathname'
require 'net/http'
require 'rubygems'
# require 'pry-byebug'


$token=ENV['DOC_BASE_TOKEN']

def main
  page = 1

  while (users_csv = get_users(page)) != '' do
    add_user_to_group(users_csv)
    page += 1
  end
end

def add_user_to_group(users_csv)
  uri = URI.parse('https://api.docbase.io/teams/lsd-inc/groups/16821/users')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === "https"
  headers = {
    'X-DocBaseToken' => $token,
    'Content-Type' => 'application/json'
  }

  json_str = "{\"user_ids\": [#{users_csv}]}"
  response = http.post(uri.path, json_str, headers)
  
  puts response.code
  puts response.body

end

def get_users(page)
  users = []
  uri = URI.parse("https://api.docbase.io/teams/lsd-inc/users?page=#{page.to_s}&per_page=100")

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === "https"

  headers = { "X-DocBaseToken" => $token }
  response = http.get(uri.path + '?' + uri.query, headers)

  json = JSON.parse(response.body)
   
  json.each do |u|
    users << u['id']
  end
  page += 1

  users.join(',')
end

main
