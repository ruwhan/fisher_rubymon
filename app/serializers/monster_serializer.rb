class MonsterSerializer < ActiveModel::Serializer
  attributes :id, :name, :power, :element_type

  has_one :user, serializer: UserViewModelSerializer
  has_one :team, serializer: TeamViewModelSerializer
  
  embed :objects
end
