class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy delete_file]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
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

  def delete_file
    if current_user.author_of?(@question)
      @attachment = ActiveStorage::Attachment.find(params[:file_id])
      @attachment.purge
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
