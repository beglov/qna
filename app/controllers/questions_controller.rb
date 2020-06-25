class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_gon_user_id, only: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  after_action :publish_question, only: :create

  include Voted

  authorize_resource

  def index
    @questions = Question.order(:created_at)
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

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      QuestionSerializer.new(@question).to_json
    )
  end

  def set_gon_user_id
    gon.user_id = current_user&.id
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
