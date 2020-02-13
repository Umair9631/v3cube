class Api::V1::SkillsController < Api::V1::ApiController
    before_action :authenticate_via_token

    def index
      @skills = Skill.select { |s| s.parent_id == 0  }
    end

    def show
      @skills =  Skill.select { |s| s.parent_id == params[:id].to_i  }
      return render json: {success: true, msg: 'skills category', data: @skills}, status: 200
    end

end
