class CommentsChannel < ApplicationCable::Channel
  def follow_questions_comments(data)
    stream_from "question_#{data['question_id']}_comments"
  end

  def follow_answers_comments(data)
    stream_from "question_#{data['question_id']}_answers_comments"
  end
end
