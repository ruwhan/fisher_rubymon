class MonsterViewModelSerializer < ActiveModel::Serializer
  attributes :id, :name, :power, :element_type, :created_at, :updated_at
end
