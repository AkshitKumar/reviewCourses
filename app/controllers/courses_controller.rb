class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user! , except: [:index, :show]
  before_action :check_user,except: [:index,:show]

  # GET /courses
  # GET /courses.json
  def index
    if !logged_in?
      redirect_to url_for(:controller=>'oauth',:action=>'index')
    end
    if params[:search].present?
      @courses = Course.search params[:search], 
                 operator: "or",
                 page: params[:page], 
                 per_page: 15, 
                 order: [number: :asc], 
                 misspellings: false, 
                 fields: [{name: :word_start},:prof,:number] ,
                 match: :word_start
    else
      id = params[:dept_id]
      prof = params[:prof]
      sem = params[:sem]
      @courses = Course.categorize(id,prof,sem).order("name ASC").paginate(:page => params[:page], :per_page => 15)
    end  
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @reviews = Review.where(course_id: @course.id).order("created_at DESC")
    if @reviews.blank?
      @avg_ratings = 0
    else
      @avg_ratings = @reviews.average(:rating).round(2)
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
      unless admin?
        redirect_to root_url, alert: "Sorry, only admins can do that"
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, :number, :prof, :credits)
    end
end
