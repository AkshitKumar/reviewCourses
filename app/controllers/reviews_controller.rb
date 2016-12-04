class ReviewsController < ApplicationController
  before_action :set_review, only: [ :edit, :update, :destroy, :upvote, :downvote]
  before_action :set_course
  before_action :authenticate_user!
  before_action :check_review, only: [:edit, :update , :destroy]
  before_action :check_vote, only: [:upvote, :downvote]
  after_action :mail , only: [:create, :update]
  # GET /reviews
  # GET /reviews.json

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.course_id = @course.id

    respond_to do |format|
      if @review.save
        @users = User.where.not(id: current_user.id, admin: 1)
        @admins = User.where.not(id: current_user.id, admin: 0)
        for user in @users
          @check = user.follow
          # raise @check.inspect
          if  !@check.nil?
            @check = @check.split(",")
            if  @check.include?(@course.dept_id.to_s)
              user.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Review", action: "create")
            end
          end
        end
        for admin in @admins
          admin.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Review", action: "create")
        end
        format.html { redirect_to course_path(@course), notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        @users = User.where.not(id: current_user.id, admin: 1)
        @admins = User.where.not(id: current_user.id, admin: 0)
        for user in @users
          @check = user.follow
          # raise @check.inspect
          if  !@check.nil?
            @check = @check.split(",")
            if  @check.include?(@course.dept_id.to_s)
              user.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Review", action: "update")
            end
          end
        end
        for admin in @admins
          admin.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Review", action: "update")
        end
        format.html { redirect_to course_path(@course), notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    # @users = User.where.not(id: current_user.id, admin: 1)
    # @admins = User.where.not(id: current_user.id, admin: 0)
    # for user in @users
    #   @check = user.follow
    #   # raise @check.inspect
    #   if  !@check.nil?
    #     @check = @check.split(",")
    #     if  @check.include?(@course.dept_id.to_s)
    #       user.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Review", action: "destroy")
    #     end
    #   end
    # end
    # for admin in @admins
    #   admin.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Review", action: "destroy")
    # end
    @review.destroy
    respond_to do |format|
      format.html { redirect_to course_path(@course), notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    count = @review.vote_count.to_i
    count+=1
    up = @review.upvote.to_i
    up+=1
    # raise up.inspect
    @vote = current_user.votes.new
    @vote.review_id = @review.id
    @vote.course_id = @course.id
    if @vote.save
      @review.update(upvote: up, vote_count: count)
      respond_to do |format|
        format.html{ redirect_to course_path(@course) }
      end
    end
  end

  def downvote
    count = @review.vote_count.to_i
    count-=1
    # raise down.inspect
    @vote = current_user.votes.new
    @vote.review_id = @review.id
    @vote.course_id = @course.id
    if @vote.save
      @review.update(vote_count: count)
      respond_to do |format|
       format.html{ redirect_to course_path(@course) }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    def check_review
      unless (@review.user == current_user) || (current_user.admin?)
        redirect_to root_url , alert: "Sorry this review belongs to someone else"
      end
    end

    def check_vote
      if @review.user == current_user
        redirect_to course_path(@review.course), alert: "You cannot vote for your own answer!"
      end

      if current_user.votes.where(review_id: @review.id, course_id: @review.course.id).present?
        redirect_to course_path(@review.course), alert: "You cannot vote more than once!"
      end
    end

    def authenticate_user!
      unless logged_in?
        store_location
        redirect_to url_for(:controller=>'oauth',:action=>'index'), alert: "You need to sign in before continuing."
      end
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:rating, :grading, :learning, :apply, :prerequisites, :usefulforcareer)
    end

    def mail
      AdminMail.review_mail(@review.course_id,@review.user_id).deliver_now
    end
end
