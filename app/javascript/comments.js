$(document).on('turbo:load', function(){
   $('.comments').on('click', '.new-comment-link', function(e) {
      e.preventDefault();
      $(this).hide();
      var klass = $(this).data('klass');
      var id = $(this).data('id');
      $('form#comment' + '-' + klass + '-' + id).removeClass('hidden');
   })
}); 

