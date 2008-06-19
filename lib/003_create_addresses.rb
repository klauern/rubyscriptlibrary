class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street_1, :null => false
      t.string :street_2
      t.string :street_3
      t.string :city
      t.string :county
      t.string :post_code, :limit => 10, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
