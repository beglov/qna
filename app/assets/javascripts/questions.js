$(document).on('turbolinks:load', function () {
    const questionsList = $('.questions-list')

    $('#question').on('click', '.edit-question-link', function (event) {
        event.preventDefault();
        $(this).hide();
        const questionId = $(this).data('questionId');
        $(`#edit-question-${questionId}`).removeClass('hidden');
    })

    $('#question').on('ajax:success', '.up-question-link, .down-question-link', function (e) {
        var question = e.detail[0];

        $(`#question .up-question-link`).hide();
        $(`#question .down-question-link`).hide();
        $(`#question .cancel-vote-question-link`).show();
        $(`#question .rating`).html(question.rating);
    }).on('ajax:success', '.cancel-vote-question-link', function (e) {
        var question = e.detail[0];

        $(`#question .up-question-link`).show();
        $(`#question .down-question-link`).show();
        $(`#question .cancel-vote-question-link`).hide();
        $(`#question .rating`).html(question.rating);
    })

    App.cable.subscriptions.create('QuestionsChannel', {
        connected: function () {
            this.perform("follow")
        },
        received: function (data) {
            questionsList.append(data)
        }
    })
})
