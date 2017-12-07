# frozen_string_literal: true

class BoxSerializer < ActiveModel::Serializer
  attributes :id, :owner_id
end
