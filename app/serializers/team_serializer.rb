class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at

  has_one :user, serializer: UserViewModelSerializer
  has_many :monsters, serializer: MonsterViewModelSerializer

  embed :objects
end
