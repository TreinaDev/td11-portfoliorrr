class ChangeCoverLetterTypeToText < ActiveRecord::Migration[7.1]
  def change
    change_column :profiles, :cover_letter, :text
  end
end
