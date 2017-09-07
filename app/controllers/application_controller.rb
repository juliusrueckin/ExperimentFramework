class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  helper_method :current_class?

  # returns "active" to be set as css class for the color indicator in the menu bar
  def current_class?(current_path)
    return "active" if request.path == current_path
  end

end
