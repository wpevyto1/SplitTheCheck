class RestaurantsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :vote]
  before_action :set_restaurant, only: %i[ show edit update destroy ]

  # GET /restaurants or /restaurants.json
  def index
    @restaurants = Restaurant.all
  end

  # GET /restaurants/1 or /restaurants/1.json
  def show
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants or /restaurants.json
  def create
    location_string = "#{params[:restaurant][:address]}, #{params[:restaurant][:city]}, #{params[:restaurant][:state]} #{params[:restaurant][:zip]}"
    params[:restaurant][:location] = location_string
    @restaurant = Restaurant.new(restaurant_params)

    vote_choice = params[:restaurant][:initial_vote]
    
    if vote_choice == "will_split"
      @restaurant.will_split = 1
      @restaurant.wont_split = 0
    elsif vote_choice == "wont_split"
      @restaurant.will_split = 0
      @restaurant.wont_split = 1
    end
  
    if @restaurant.save
      redirect_to @restaurant, notice: "Restaurant was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /restaurants/1 or /restaurants/1.json
  def update
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to @restaurant, notice: "Restaurant was successfully updated." }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1 or /restaurants/1.json
  def destroy
    @restaurant.destroy!

    respond_to do |format|
      format.html { redirect_to restaurants_path, status: :see_other, notice: "Restaurant was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def vote
    @restaurant = Restaurant.find(params[:id])
    vote_type = params[:vote]

    if current_user.voted_restaurants.include?(@restaurant)
      redirect_to restaurant_path(@restaurant), alert: "You've already voted on this restaurant."
      return
    end

    VoteHistory.create(user: current_user, restaurant: @restaurant, vote_type: vote_type)

    if vote_type == 'will_split'
      @restaurant.increment!(:will_split)
    elsif vote_type == 'wont_split'
      @restaurant.increment!(:wont_split)
    end
    
    redirect_to restaurant_path(@restaurant), notice: "Your vote has been counted."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def restaurant_params
      params.require(:restaurant).permit(:name, :location, :will_split, :wont_split)
    end
end
