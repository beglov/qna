module AnswersHelper
  def answer_form_options(answer)
    if answer.new_record?
      {model: [answer.question, answer]}
    else
      {model: answer, class: 'hidden', id: "edit-answer-#{answer.id}"}
    end
  end

  def answer_errors_div_id(answer)
    answer.new_record? ? 'new-answer-errors' : "answer-#{answer.id}-errors"
  end
end
