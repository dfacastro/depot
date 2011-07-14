class ApplicationController < ActionController::Base
  before_filter :set_i18n_locale_from_params
  before_filter :authorize
  protect_from_forgery

  private
    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end

=begin
    def current_count
      if session[:count].nil?
        session[:count] = 0
      else
        session[:count]
      end
    end
=end

    def inc_count
      session[:count] ||= 0
      session[:count] += 1
      #session[:count] = current_count + 1
    end

  protected
    def authorize
      unless User.find_by_id(session[:user_id]) or (session[:user_id] and User.count.zero?)
        redirect_to login_url, :notice => "Please log in"
      end
    end

    def set_i18n_locale_from_params
      if params[:locale]
        if I18n.available_locales.include?(params[:locale].to_sym)
          I18n.locale = params[:locale]
        else
          flash.now[:notice] =
            "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end
    end

    def default_url_options
      { :locale => I18n.locale }
    end

end
