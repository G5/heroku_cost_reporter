class OrganizationsController < ApplicationController
  def index
    @organizations = Heroku::Organization.all_organizations(clear_cache)
    @organization_invoices = Heroku::Organization
  end

  private
    def clear_cache
      params[:clear_cache].present?
    end
end
