class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :load_answer, only: %i[show edit update destroy select_best]

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
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
