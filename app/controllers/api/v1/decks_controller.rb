class DecksController < ApplicationController

before_action :valid_user

    def index
        @decks = @user.decks
        render json: @decks.to_json(
        include: {
            cards: { only: [
                :id,
                :deck_id, 
                :question, 
                :answer
            ]}
        }, except: [:created_at, :updated_at]
        )
    end 

    def create
        @deck = @user.decks.build(deck_params)

        if @deck.save
        render json: {
            deck: @deck, except: [:created_at, :updated_at]
        }
        else 
        render json: { errors: @deck.errors.full_messages }
        end

    end

    def destroy
        @deck = @user.decks.find_by(id: params[:id])
        if @deck
        @deck.destroy 
        render json: {
            deleted: true,
            deck: @deck, except: [:created_at, :updated_at]
        }
        else 
        render json: {
            deleted: false,
            errors: "You must log in to perform this action"
        }
        end
    end

    def valid_user
        @user = User.find_by(id: params[:user_id])
        if @user && @user == current_user
        @user
        else
        render json: {error: "You must be logged in to perform this action."}
        end
    end

    private 

    def deck_params
        params.require(:deck).permit(:title)
    end


end

