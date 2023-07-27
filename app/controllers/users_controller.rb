class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :add_balance]

  def show
    @user = current_user
    @balance = @user.eth_balance["result"]
  end

  def add_balance
    EthTransferWorker.perform_async(current_user.id)
    redirect_to "/profile", :flash => { notice: 'Balance addition has been queued.' }
  end

end
