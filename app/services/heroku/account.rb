module Heroku
  class Account < Base

    attr_accessor :email,
                  :name

    def self.info
      response = Request.where('account')
      Account.new(response)
    end

    def initialize(args = {})
      super(args)
    end
  end
end
