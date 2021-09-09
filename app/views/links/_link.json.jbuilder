# frozen_string_literal: true

json.extract! link, :id, :original, :username, :frequency, :shortened, :created_at, :updated_at
json.url api_v1_link_url(link, format: :json)
