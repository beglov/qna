class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    @questions = Question.order(:created_at)
    render json: @questions
  end

  def show
    @questions = Question.find(params[:id])
    render json: @questions, serializer: QuestionShowSerializer
  end
end
