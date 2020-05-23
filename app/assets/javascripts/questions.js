$(document).on('turbolinks:load', function () {
    $('#question').on('click', '.edit-question-link', function (event) {
        event.preventDefault();
        $(this).hide();
        const questionId = $(this).data('questionId');
        $(`#edit-question-${questionId}`).removeClass('hidden');
    })
})
