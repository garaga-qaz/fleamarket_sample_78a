class ChangeDataPrefectureToUser < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :prefecture, :integer
  end
end
