class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name, :null => false
      t.string :telephone, :limit => 50
      t.string :fax, :limit => 50
      t.string :website
      t.integer :address_id
      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
