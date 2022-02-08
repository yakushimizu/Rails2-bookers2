class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :book_tags,dependent: :destroy
  has_many :tags,through: :book_tags

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def save_tags(savebook_tags)
    # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - savebook_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = savebook_tags - current_tags

    # 古いタグを消す
    old_tags.each do |old_name|
      self.tags.delete　Tag.find_by(name:old_name)
    end

    # 新しいタグを保存
    new_tags.each do |new_name|
      book_tag = Tag.find_or_create_by(name:new_name)
      self.tags << book_tag
   end
  end

  def self.search_for(word, method)
    if method == 'perfect'
      Book.where(title: word)
    elsif method == 'forward'
      Book.where('title LIKE ?', word+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+word)
    else
      Book.where('title LIKE ?', '%'+word+'%')
    end
  end
end