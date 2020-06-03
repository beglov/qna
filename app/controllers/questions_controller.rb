class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy up down]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
    @question.build_reward
  end

  def edit
  end

  def create
    @question = Question.new(question_params.merge(user_id: current_user.id))

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    unless current_user.author_of?(@question)
      return redirect_to questions_path, notice: 'Delete unavailable! You are not the author of the question.'
    end

    @question.destroy
    redirect_to questions_path, notice: 'Question was successfully deleted.'
  end

  def up
    unless current_user.author_of?(@question)
      @question.votes.create_with(negative: false).find_or_create_by(user_id: current_user.id)
    end

    render json: {id: @question.id, rating: @question.rating}
  end

  def down
    unless current_user.author_of?(@question)
      @question.votes.create_with(negative: true).find_or_create_by(user_id: current_user.id)
    end

    render json: {id: @question.id, rating: @question.rating}
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url],
                                                    reward_attributes: %i[title file])
  end
end
