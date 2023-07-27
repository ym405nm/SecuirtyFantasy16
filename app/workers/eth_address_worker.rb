require 'ethereum'

class EthAddressWorker
  include Sidekiq::Worker

  def perform(user_id)
    Rails.logger.info "EthAddressWorker has started. user_id: #{user_id}"

    # Connect to Ethereum node
    client = Ethereum::HttpClient.new('http://localhost:8545')

    # Generate new Ethereum account
    password = ENV['ETH_ACCOUNT_PASSWORD'] # Get password from environment variable
    address = client.personal_new_account(password)
    result_address = address['result']

    user = User.find(user_id)
    # Update the user with the new Ethereum address
    if user.update(eth_address: result_address)
      Rails.logger.info "EthAddressWorker has updated the user #{user_id}."
    else
      Rails.logger.error "EthAddressWorker couldn't update the user #{user_id}."
    end
  end
end
