$(document).on('turbo:load', function(){
  $('.rate .voting').on('ajax:success', function(e){
    var data = e.detail[0];
    var likeClass = '.' + data.klass + '-' + data.id
    $(likeClass + ' .rating').html('rating: ' + data.rating);
    $(likeClass + ' .voting').addClass('hidden');
    $(likeClass + ' .revoke-link').removeClass('hidden');
  })

  $('.revoke').on('ajax:success', function(e){
    var data = e.detail[0];
    var likeClass = '.' + data.klass + '-' + data.id
    $(likeClass + ' .rating').html('rating: ' + data.rating);
    $(likeClass + ' .revoke-link').addClass('hidden');
    $(likeClass + ' .voting').removeClass('hidden');
  })
}); 