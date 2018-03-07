module Heroku
  class Organization < Base
      attr_accessor :name

      CACHE_DEFAULTS = { expires_in: 7.days, force: false }

     def self.all_organizations(clear_cache)
       cache = CACHE_DEFAULTS.merge({ force: clear_cache })
       response = Request.where('organizations', cache)
       @organizations = response.map { |organization| Organization.new(organization) }
     end

     def self.find(name)
       response = Request.get("organizations/#{name}/invoices")
       Organizations.new(response)
     end

     def initialize(args = {})
       super(args)
     end
  end
end
