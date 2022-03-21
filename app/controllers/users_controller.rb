class UsersController < ApplicationController
    before_action :find_user,only:[:show,:update,:destroy]
    def index
        @users = User.all.order("id DESC")
        render json:{ success: true, users:@users}, status: 200
    end

    def show
        render json:{ success: true, users:@user}, status: 200
    end

    def create
        @user = User.create(user_params)
        if @user.valid?
            if @user.save
                render json:{ success: true, message:'User data save successfully'}, status: 200
            else
                render json: { success: false, errors: 'An error occurred'},status: :unprocessable_entity
            end
        else
            render json: { success: false, errors: @user.errors},status: :unprocessable_entity
        end
    end

    def update
        if @user.update(user_params)
            render json:{ success: true, message:'User data update successfully'}, status: 200
        else
            if @user.valid?
                render json: { success: false, errors: 'An error occurred'},status: :unprocessable_entity
            else
                render json: { success: false, errors: @user.errors}
            end
        end
    end

    def destroy 
        @user.destroy
        render json:{ success: true, message:'User destroy successfully'}, status: 200           
    end

    def typeahead
        @search = params[:input]
        @users = User.any_of({"firstName": /#{@search}/}, {"lastName": /#{@search}/}, {"email": /#{@search}/})
        render json:{ success: true, users:@users}, status: 200
    end 


    private
    def user_params
        params.require(:user).permit(:firstName, :lastName, :email)
    end
    def find_user
        begin
          @user = User.find(params[:id])
        rescue  => e
          render json:{ success: false, message:e.message}
        end
    end
end
