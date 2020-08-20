class SessionsController < ApplicationController

    def create
        user = User
                .find_by(email: params[:user][:email])
                .try(:authenticate, params[:user][:password])

        if user
            session[:user_id] = user.id
            render json: {
                user: current_user.as_json(except: [:password_digest, :created_at, :updated_at]),
                logged_in: logged_in?
            }
        else 
            render json: { 
                error: "Invalid credentials",
                logged_in: logged_in?
            }
        end
    end

        def get_current_user
            render json: {
                logged_in: logged_in?,
                user: current_user.as_json(except: [:password_digest, :created_at, :updated_at])
            }
        end

        def destroy
            reset_session
            render json: {
                logged_in: logged_in?
            }
        end

end