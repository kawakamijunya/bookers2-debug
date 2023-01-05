class Room < ApplicationRecord

  has_many :users, through: :user_rooms
  has_many :user_rooms, dependent: :destroy #1つのルームにいるユーザ数は2人のためhas_manyになる
  has_many :chats, dependent: :destroy

end
