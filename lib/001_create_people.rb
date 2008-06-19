class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :title
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :email, :limit => 100, :null => false
      t.string :telephone, :limit => 50
      t.string :mobile_phone, :limit => 50
      t.string :job_title
      t.date :date_of_birth
      t.string :gender, :limit => 1
      t.string :keywords
      t.text :notes
      t.integer :address_id
      t.integer :company_id
      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
