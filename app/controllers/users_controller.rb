class UsersController < ApplicationController
	
  def following
    p = params[:follow]
    if !p.nil?
      l= params[:follow].length
      # raise p.inspect
      i=0
      cats=Array.new
      while i<20 do
        i+=1
        cat=params[:follow][i.to_s]
        cats.push cat
      end
    else
      cats=Array.new
    end
    cats.compact!
    cats=cats.join(',')
    # raise cats.inspect
    user=current_user
    user.update(follow: cats)
    respond_to do |format|
      format.html{redirect_to root_url, notice: "Your choices have been saved."}
   end
  end
end
