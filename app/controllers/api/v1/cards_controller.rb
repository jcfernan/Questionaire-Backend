class Api::V1::CardsController < ApplicationController

    before_action :valid_user

    def create
        @deck = @user.decks.find_by(id: params[:deck_id])
        @card = @deck.cards.build(card_params)
        if @card.save
            render json: {
                card: @card, except: [:created_at, :updated_at]
            }
        else 
            render json: { errors: @card.errors.full_messages }
        end
    end

def destroy
    @card = @user.cards.find_by(id: params[:id])
    if @card
        @card.destroy 
        render json: {
            deleted: true,
            card: @card, except: [:created_at, :updated_at]
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

def card_params
    params.require(:card).permit(:question, :answer)
end

end

end
