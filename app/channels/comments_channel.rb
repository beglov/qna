class CommentsChannel < ApplicationCable::Channel
  def follow_questions_comments
    stream_from 'questions_comments'
  end

  def follow_answers_comments
    stream_from 'answers_comments'
  end
end
