class Relationship < ApplicationRecord
  #class_name: "UserでUserモデルを参照"
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
