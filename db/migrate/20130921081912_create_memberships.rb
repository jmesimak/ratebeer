class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :beer_club
      t.belongs_to :user
      t.datetime :join_date
      t.timestamps
    end
  end
end
