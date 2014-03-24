class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.string :site
      t.string :cdn
      t.string :file
      t.float :mesurement
      t.integer :status
      t.datetime :date

      t.timestamps
    end
  end
end
