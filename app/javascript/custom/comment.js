import $ from 'jquery';
$(document).on('turbolinks:load',function(){
  $(document).on('click', '.create-comment-link', function (e) {
    e.preventDefault();
    var commentableId = $(this).data('commentableId');
    var commentableType = $(this).data('commentableType');
    $('form#' + commentableType + '-' + commentableId + '-' + 'comment').removeClass('hidden');
  });
});
