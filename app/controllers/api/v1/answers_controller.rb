class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[index create]
  before_action :load_answer, only: %i[show update destroy]
  authorize_resource

  def index
    render json: @question.answers
  end

  def show
    render json: @answer, serializer: AnswerShowSerializer
  end

  def create
    @answer = @question.answers.create!(answer_params.merge(user_id: current_resource_owner.id))
    json_response(@answer, :created)
  end

  def update
    @answer.update(answer_params)
    json_response(@answer)
  end

  def destroy
    @answer.destroy
    head :no_content
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end
end
