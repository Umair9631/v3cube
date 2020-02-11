class Api::V1::SkillsController < Api::V1::ApiController
    before_action :authenticate_via_token

    def index
      @skills = Skill.all.map { |s| s.parent_id == 0  }
      return render json: { success: true, msg: 'Skills List.', data: @skills} , status: 200
    end

end
