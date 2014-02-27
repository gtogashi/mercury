class CreatePages < ActiveRecord::Migration
  def change
    create_table :mercury_pages, :force => true do |t|
      t.string   :name,  :null => false
      t.text     :contents
      t.timestamps
    end
    add_index :pages, :name, :unique => true
  end
end
