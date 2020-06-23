class Api::V1::QuestionsController < Api::V1::BaseController
  skip_authorization_check

  def index
    @questions = Question.order(:created_at)
    render json: @questions.to_json(include: :answers)
  end
end
