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

    if ($question.length) {
        const questionId = $question.data('questionId')
        App.cable.subscriptions.create('AnswersChannel', {
            connected: function () {
                this.perform("follow", {question_id: questionId})
            },
            received: function (data) {
                data = JSON.parse(data)
                $('.answers').append(`<div id="answer-${data.id}"><p>Rating: <span class="rating">${data.rating}</span></p><p>${data.body}</p></div>`)
            }
        })
        App.cable.subscriptions.create('CommentsChannel', {
            connected: function () {
                this.perform("follow_questions_comments")
            },
            received: function (data) {
                data = JSON.parse(data)
                $(`#question-${data.commentable_id} .comments`).append(`<li class="list-group-item" id="comment-${data.id}">${data.body}</li>`)
            }
        })
    }
    if (questionsList.length) {
        App.cable.subscriptions.create('QuestionsChannel', {
            connected: function () {
                this.perform("follow")
            },
            received: function (data) {
                questionsList.append(data)
            }
        })
    }
})
