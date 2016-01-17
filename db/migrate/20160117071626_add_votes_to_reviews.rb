class AddVotesToReviews < ActiveRecord::Migration
  def change
  	add_column :reviews, :vote_count, :integer, defualt: 0
  	add_column :reviews, :upvote, :integer, defualt: 0
  end
end
