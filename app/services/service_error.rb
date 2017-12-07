class ServiceError < StandardError
  attr_accessor :object

  def initialize(object = nil, message = nil)
    self.object = object
    super(message)
  end

  class BoxOwnerRemover < ServiceError; end
end