class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.string :emp_id
      t.float :time_in_office
      t.float :time_out_office
      t.string :source
      t.date :report_date

      t.timestamps
    end
  end
end
