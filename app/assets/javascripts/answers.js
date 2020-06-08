$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (event) {
        event.preventDefault();
        $(this).hide();
        const answerId = $(this).data('answerId');
        $(`#edit-answer-${answerId}`).removeClass('hidden');
    })

    $('.answers').on('ajax:success', '.up-answer-link, .down-answer-link', function (e) {
        var answer = e.detail[0];

        $(`#answer-${answer.id} .up-answer-link`).hide();
        $(`#answer-${answer.id} .down-answer-link`).hide();
        $(`#answer-${answer.id} .cancel-vote-answer-link`).show();
        $(`#answer-${answer.id} .rating`).html(answer.rating);
    })

    $('.answers').on('ajax:success', '.cancel-vote-answer-link', function (e) {
        var answer = e.detail[0];

        $(`#answer-${answer.id} .up-answer-link`).show();
        $(`#answer-${answer.id} .down-answer-link`).show();
        $(`#answer-${answer.id} .cancel-vote-answer-link`).hide();
        $(`#answer-${answer.id} .rating`).html(answer.rating);
    })
})
