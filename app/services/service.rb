# frozen_string_literal: true

module Service
  extend ActiveSupport::Concern
  class_methods do
    def run(*args)
      new(*args).run
    end
  end
end
