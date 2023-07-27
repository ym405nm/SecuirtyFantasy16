class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_commit :add_eth_address, on: :create

  def eth_balance
    client = Ethereum::HttpClient.new('http://localhost:8545')
    balance = client.eth_get_balance(self.eth_address)
    # ... convert balance to desired format and return it ...
  end

  private

  def add_eth_address
    EthAddressWorker.perform_async(self.id)
  end

end
