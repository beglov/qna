class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :load_answer, only: %i[show edit update destroy select_best]
  after_action :publish_answer, only: :create

  include Voted

  def show
  end

  def new
    @answer = Answer.new
  end

  def edit
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def select_best
    @answer.select_best! if current_user.author_of?(@answer)
  end

  private

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{@answer.question_id}",
      ApplicationController.render(json: @answer.attributes.merge(rating: @answer.rating))
    )
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end
end
