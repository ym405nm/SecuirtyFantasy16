# app/workers/concerns/ethereum_contract.rb

require 'ethereum.rb'
require 'json'

module EthereumContract
  def create_contract
    client = Ethereum::HttpClient.new('http://localhost:8545')
    contract_abi = JSON.parse(File.read(Rails.root.join('app', 'data', 'abi.json')))
    contract_address = ENV["ETH_CONTRACT_ADDRESS"]
    Ethereum::Contract.create(
      client: client,
      address: contract_address,
      name: "MonsterExtendedNFT",
      abi: contract_abi)
  end
end
