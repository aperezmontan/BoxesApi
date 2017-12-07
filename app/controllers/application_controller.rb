# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ActionController::HttpAuthentication::Token::ControllerMethods

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render :json => { :error => exception.message }, :status => :unprocessable_entity, :adapter => :json
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :json => { :error => exception.message }, :status => :not_found, :adapter => :json
  end

  rescue_from ArgumentError do |exception|
    render :json => { :error => exception.message }, :status => :unprocessable_entity, :adapter => :json
  end

  rescue_from ServiceError::BoxOwnerRemover do |exception|
    render :json => { :error => exception.message }, :status => :forbidden, :adapter => :json
  end
end
