class UserController < ApplicationController
  
  def new
  	@user = User.new
  end

  def show
  	begin
  		@user = User.find_by id:params[:id]
  	rescue Exception => e
 		
  	end
  end

#   def create
#    @user = User.new params[:user]
# 	if @user.save
# # Not the final implementation!
#     else
# # Handle a successful save.
# 		render :new
#    end
	def all
		@user = User.all
	end

	def create
		@user = User.new(user_params)
		#debugger
		if @user.save
			log_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		 else
		 	@user
		 	render :error_messages
		end

	end

	private 
	def user_params
		params.require(:user).permit :name,:email,:password,:password_confirmation
	end
end
