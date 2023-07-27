class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_commit :add_eth_address, on: :create

  private

  def add_eth_address
    EthAddressWorker.perform_async(self.id)
  end

end
