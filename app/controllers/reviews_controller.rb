class ReviewsController < ApplicationController
  before_action :set_review, only: [ :edit, :update, :destroy]
  before_action :set_course
  before_action :authenticate_user!
  before_action :check_review, only: [:edit, :update , :destroy]
  after_action :mail , only: [:create]
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
        User.find_each do |user|
          @check = user.follow
          if  !@check.nil?
            @check = @check.split(",")
          end
          if  @check.include?(@course.dept_id.to_s)
            user.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Review", action: "create")
          end
        end
        format.html { redirect_to course_path(@course), notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
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
        User.find_each do |user|
          @check = user.follow
          if  !@check.nil?
            @check = @check.split(",")
          end
          if  @check.include?(@course.dept_id.to_s)
            user.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Review", action: "update")
          end
        end
        format.html { redirect_to course_path(@course), notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    User.find_each do |user|
      @check = user.follow
      if  !@check.nil?
        @check = @check.split(",")
      end
      if  @check.include?(@course.dept_id.to_s)
        user.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Review", action: "destroy")
      end
    end
    @review.destroy
    respond_to do |format|
      format.html { redirect_to course_path(@course), notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
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

    def authenticate_user!
      unless logged_in?
        redirect_to root_url, alert: "You need to sign in before continuing."
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
