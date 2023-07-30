require 'ethereum.rb'
require 'json'
require_relative './concerns/ethereum_contract'

class EthereumConnectionWorker
  include Sidekiq::Worker
  include EthereumContract

  def perform
    begin
      contract = create_contract
      Rails.logger.info "Successfully connected to Ethereum network and fetched contract: #{contract.inspect}"
    rescue => e
      Rails.logger.error "Failed to connect to Ethereum network or fetch contract: #{e.message}"
    end
  end
end
