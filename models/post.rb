class Post < ActiveRecord::Base
  validates :title, presence: true, length: {maximum: 255}
  validates :content, presence: true
end
