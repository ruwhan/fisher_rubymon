class Api::V1::MonstersController < Api::V1::BaseApiController
  before_action :authenticate_with_token!

  def show 
    @monster = current_user.monsters.find params[:id]
    render :json => @monster
  end

  def index
    render :json => current_user.monsters
  end

  def create 
    monster = current_user.monsters.build(monster_params)

    if monster.save
      render :json => monster, status: 201, location: [:api, monster]
    else
      render :json => { errors: monster.errors }, status: 422
    end
  end

  def update 
    monster = current_user.monsters.find(params[:id])

    if monster.update(monster_params)
      render :json => monster, status: 200, location: [:api, monster]
    else
      render :json => { errors: monster.errors }, status: 422
    end
  end

  def destroy 
    monster = current_user.monsters.find(params[:id])
    monster.destroy
    head 204
  end

private
  def monster_params
    params.require(:monster).permit(:name, :power, :element_type, :team_id)
  end
end
