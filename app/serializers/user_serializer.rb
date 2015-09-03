class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :created_at, :updated_at, :auth_token

  has_many :monsters, serializer: MonsterViewModelSerializer
  has_many :teams, serializer: TeamViewModelSerializer
  
  embed :objects
end
