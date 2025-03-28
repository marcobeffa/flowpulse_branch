# == Schema Information
#
# Table name: external_posts
#
#  id            :integer          not null, primary key
#  branch_id     :integer          not null
#  api_variabile :string
#  content       :json
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_external_posts_on_branch_id  (branch_id)
#

# app/models/external_post.rb

require 'httparty'

class ExternalPost < ApplicationRecord
  belongs_to :branch

  BASE_URL = "https://note.flowpulse.net/api/v1"  # 👈 parte fissa dell'API

  def fetch_and_save_content
    return if api_variabile.blank?

    full_url = "#{BASE_URL}/#{api_variabile}"
    Rails.logger.info("Fetching from API: #{full_url}")

    response = HTTParty.get(full_url, headers: {
      "Accept" => "application/json",
      "User-Agent" => "FlowpulseRubyClient/1.0"
    })

    if response.success?
      update_column(:content, response.parsed_response)
    else
      Rails.logger.warn("Errore API Flowpulse: #{response.code} - #{response.body}")
    end
  rescue => e
    Rails.logger.error("Errore fetch: #{e.message}")
  end
end
