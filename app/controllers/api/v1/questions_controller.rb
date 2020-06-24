class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: %i[show update destroy]
  authorize_resource

  def index
    @questions = Question.order(:created_at)
    render json: @questions
  end

  def show
    render json: @question, serializer: QuestionShowSerializer
  end

  def create
    @question = current_resource_owner.questions.create!(question_params)
    json_response(@question, :created)
  end

  def update
    @question.update(question_params)
    json_response(@question)
  end

  def destroy
    @question.destroy
    head :no_content
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: %i[name url],
      reward_attributes: %i[title file]
    )
  end
end
