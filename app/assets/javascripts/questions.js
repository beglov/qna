$(document).on('turbolinks:load', function () {
    const $question = $('.question')
    const questionsList = $('.questions')

    $question.on('click', '.edit-question-link', function (event) {
        event.preventDefault();
        $(this).hide();
        const questionId = $(this).data('questionId');
        $(`#edit-question-${questionId}`).removeClass('hidden');
    })

    $question.on('ajax:success', '.up-question-link, .down-question-link', function (e) {
        const question = e.detail[0];

        $(`.question .up-question-link`).hide();
        $(`.question .down-question-link`).hide();
        $(`.question .cancel-vote-question-link`).show();
        $(`.question .rating`).html(question.rating);
    }).on('ajax:success', '.cancel-vote-question-link', function (e) {
        const question = e.detail[0];

        $(`.question .up-question-link`).show();
        $(`.question .down-question-link`).show();
        $(`.question .cancel-vote-question-link`).hide();
        $(`.question .rating`).html(question.rating);
    })

    if (questionsList.length) {
        App.cable.subscriptions.create('QuestionsChannel', {
            connected: function () {
                this.perform("follow")
            },
            received: function (data) {
                questionsList.append(JST["templates/question"](JSON.parse(data)))
            }
        })
    }
    if ($question.length) {
        const questionId = $question.data('questionId')

        App.cable.subscriptions.create('AnswersChannel', {
            connected: function () {
                this.perform("follow", {question_id: questionId})
            },
            received: function (data) {
                data = JSON.parse(data)

                if (gon.user_id !== data.user_id){
                    $('.answers').append(JST["templates/answer"](data))
                }
            }
        })

        App.cable.subscriptions.create('CommentsChannel', {
            connected: function () {
                this.perform("follow_questions_comments", {question_id: questionId})
            },
            received: function (data) {
                data = JSON.parse(data)

                if (gon.user_id !== data.user_id){
                    $(`#question-${data.commentable_id} .comments`).append(JST["templates/comment"](data))
                }
            }
        })
    }
})
