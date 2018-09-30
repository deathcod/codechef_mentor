class MessagesController < ApplicationController
  before_action :authenticate_request!
end
