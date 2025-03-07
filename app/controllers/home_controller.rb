class HomeController < ApplicationController
  # Public pages don't require authentication
  def index
    # Show the same landing page to all users
    # You can customize this action to show different content for logged in users
  end

  private

  def devise_configured?
    defined?(Devise)
  end
end
