import $ from 'jquery';
$(document).on('turbolinks:load',function(){
  $('.vote').on('ajax:success', function(e) {
    var resourceClass = e.detail[0]['resource_class'];
    var resourceId = e.detail[0]['resource'];
    var resourceVotes = e.detail[0]['votes'];
    $('#' + resourceClass + '_' + resourceId + ' .votes').append("Total Votes: " + resourceVotes);
  });
});