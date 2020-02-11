class Api::V1::SkillsController < Api::V1::ApiController
    before_action :authenticate_via_token

    def index
      @skills = Skill.all.map { |s| s.parent_id == 0  }
    end

end
