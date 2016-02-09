class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user! 
  before_action :check_user,except: [:index,:show]

  # GET /courses
  # GET /courses.json
  def index
    if params[:search].present?
      @courses = Course.where('(name LIKE ?) OR (number LIKE ?) OR (prof LIKE ?)', "%#{params[:search]}%", "%#{params[:search]}%","%#{params[:search]}%").paginate(:page => params[:page], :per_page => 15)
    else  
      id = params[:dept_id]
      prof = params[:prof]
      sem = params[:sem]
      @courses = Course.categorize(id,prof,sem).order("number ASC").paginate(:page => params[:page], :per_page => 15)
    end  
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    mark_as_read
    @reviews = Review.where(course_id: @course.id).order("vote_count DESC" ,"created_at DESC")
    if @reviews.blank?
      @avg_ratings = 0
    else
      @avg_ratings = @reviews.average(:rating).round(2)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        @users = User.where.not(id: current_user.id, admin: 1)
        @admins = User.where.not(id: current_user.id, admin: 0)
        for user in @users
          @check = user.follow
          # raise @check.inspect
          if  !@check.nil?
            @check = @check.split(",")
            if  @check.include?(@course.dept_id.to_s)
              user.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Course", action: "create")
            end
          end
        end
        for admin in @admins
          admin.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Course", action: "create")
        end
        %x(bundle exec rake search_suggestions:index)
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        @users = User.where.not(id: current_user.id, admin: 1)
        @admins = User.where.not(id: current_user.id, admin: 0)
        for user in @users
          @check = user.follow
          # raise @check.inspect
          if  !@check.nil?
            @check = @check.split(",")
            if  @check.include?(@course.dept_id.to_s)
              user.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Course", action: "update")
            end
          end
        end
        for admin in @admins
          admin.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Course", action: "update")
        end
        %x(bundle exec rake search_suggestions:index)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    # @users = User.where.not(id: current_user.id, admin: 1)
    #     @admins = User.where.not(id: current_user.id, admin: 0)
    #     for user in @users
    #       @check = user.follow
    #       # raise @check.inspect
    #       if  !@check.nil?
    #         @check = @check.split(",")
    #         if  @check.include?(@course.dept_id.to_s)
    #           user.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Course", action: "destroy")
    #         end
    #       end
    #     end
    #     for admin in @admins
    #       admin.notifications.create(user_id: user.id, owner_id: current_user.id, course_id: @course.id, read: false, notif_type: "Course", action: "destroy")
    #     end
    @course.destroy
    respond_to do |format|
      %x(bundle exec rake search_suggestions:index)
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    def check_user
      unless current_user.admin?
        redirect_to root_url, alert: "Sorry, only admins can do that"
      end
    end

    def authenticate_user!
      unless logged_in?
        store_location
        redirect_to url_for(:controller=>'oauth',:action=>'index'), alert: "You need to sign in before continuing."
      end
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, :number, :prof, :credits)
    end

    def mark_as_read
        @unread = current_user.notifications.where(read: false, course_id: @course.id)
        @unread.each do |unread|
            unread.update_attribute(:read, true)
        end
    end
end
