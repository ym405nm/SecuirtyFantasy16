require 'ethereum.rb'
require 'json'
require 'csv'
require_relative './concerns/ethereum_contract'

class MonsterCreationWorker
  include Sidekiq::Worker
  include EthereumContract

  def perform
    contract = create_contract
    Rails.logger.info "Successfully created contract: #{contract.inspect}"

    Rails.logger.info "Load CSV File"

    csv_data = CSV.read(Rails.root.join('app', 'data', 'monsters.csv'), headers: true)
    csv_data.each do |row|
      # Get the data
      name = row['Name']
      attack_power = row['Attack Power'].to_i
      defense_power = row['Defense Power'].to_i
      catch_rate = row['Catch Rate'].to_i

      Rails.logger.info "Call the smart contract method : #{name}"
      contract.transact_and_wait.create_monster(name, attack_power, defense_power, catch_rate)

    end
  end
end
