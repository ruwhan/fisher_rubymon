class Api::V1::TeamsController < Api::V1::BaseApiController
  before_action :authenticate_with_token!

  def show 
    @team = current_user.teams.find(params[:id])
    render :json => @team
  end

  def index 
    @team = current_user.teams
    render :json => @team
  end

  def create 
    team = current_user.teams.build(team_params)

    if team.save
      render :json => team, status: 201, location: [:api, team]
    else
      render :json => { errors: team.errors }, status: 422
    end
  end

  def update
    team = current_user.teams.find(params[:id])

    if team.update(team_params) 
      render :json => team, status: 200, location: [:api, team]
    else
      render :json => { errors: team.errors }, status: 422
    end
  end

  def destroy
    team = current_user.teams.find(params[:id])
    team.destroy

    head 204
  end

private
  def team_params
    params.require(:team).permit(:name, :monster_ids => [])
  end
end
