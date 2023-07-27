# app/workers/eth_transfer_worker.rb

require 'ethereum.rb'

class EthTransferWorker
  include Sidekiq::Worker

  def perform(user_id, amount = "0x3e8")
    user = User.find(user_id)
    coinbase = ENV['ETH_COINBASE_ADDRESS']
    coinbase_password = ENV['ETH_COINBASE_PASSWORD']
    account_password = ENV['ETH_ACCOUNT_PASSWORD']

    if user.eth_address.present?
      # Set up a client
      client = Ethereum::HttpClient.new('http://localhost:8545')
      logger.info "Client is set up."

      # Unlock the coinbase account
      client.personal_unlock_account(coinbase, coinbase_password)
      logger.info "Coinbase account #{coinbase} is unlocked."

      # Unlock the user's account
      client.personal_unlock_account(user.eth_address, account_password)
      logger.info "User's account #{user.eth_address} is unlocked."

      # Send transaction
      tx_hash = client.eth_send_transaction(from: coinbase, to: user.eth_address, value: amount)
      logger.info "Transaction is sent. Transaction hash: #{tx_hash}"
    else
      logger.error "Error: User #{user_id} has no ETH address."
    end
  end

end
