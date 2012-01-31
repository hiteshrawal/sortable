class Book < ActiveRecord::Base
  belongs_to :author
  validates_presence_of :name
  acts_as_sortable :name, :genre, :'author.name'
end