ActiveRecord::Schema.define :version => 0 do
  create_table :books, :force => true do |t|
    t.column :name, :string
    t.column :genre, :string
    t.column :author_id, :integer
    t.column :position, :integer
  end

  create_table :authors, :force => true do |t|
    t.column :name, :string
    t.column :position, :integer
  end
end