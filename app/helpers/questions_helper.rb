module QuestionsHelper
  def question_form_options(question)
    if question.new_record?
      {model: question, local: true}
    else
      {model: question, class: 'hidden', id: "edit-question-#{question.id}"}
    end
  end
end
