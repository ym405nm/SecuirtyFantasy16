# app/workers/monster_retrieval_worker.rb

require_relative './concerns/ethereum_contract'

class MonsterRetrievalWorker
  include Sidekiq::Worker
  include EthereumContract

  def perform
    contract = create_contract

    # 現在のモンスターの数を取得します。
    monster_count = contract.call.total_supply
    Rails.logger.info "Monster Count is #{monster_count}"

    (0...monster_count).each do |i|
      view_monster = contract.call.view_monster(i)
      Rails.logger.info "Monster #{i} name is #{view_monster[0]}"
    end


  end
end
