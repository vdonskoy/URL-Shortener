class CreateVisitTable < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :shortened_url_id
      t.integer :user_id

      t.timestamps
    end

    add_index(:visits, :shortened_url_id)
    add_index(:visits, :user_id)
  end
end
