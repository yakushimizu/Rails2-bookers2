class Tag < ApplicationRecord
  has_many :book_tags,dependent: :destroy, foreign_key: 'tag_id'
  has_many :books,through: :book_tags

  scope :merge_books, -> (tags){ }

  def self.search_books_for(word, method)

    if method == 'perfect'
      tags = Tag.where(name: word)
    elsif method == 'forward'
      tags = Tag.where('name LIKE ?', word + '%')
    elsif method == 'backward'
      tags = Tag.where('name LIKE ?', '%' + word)
    else
      tags = Tag.where('name LIKE ?', '%' + word + '%')
    end

    return tags.inject(init = []) {|result, tag| result + tag.books}

  end
end
