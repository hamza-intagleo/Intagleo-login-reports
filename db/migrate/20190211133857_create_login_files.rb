class CreateLoginFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :login_files do |t|
      t.string :filename
      t.timestamps
    end
  end
end
