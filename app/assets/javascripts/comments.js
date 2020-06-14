document.addEventListener('turbolinks:load', () => {
    $('.add-comment-link').on('click', function (event) {
        event.preventDefault();

        $('#addCommentModal form').attr('action', $(this).data('url'));
        $('#addCommentModal').modal('show');
    })
});
