import consumer from "./consumer"

$(document).on('turbo:load', function(){
  var path = $(location).attr('pathname').split('/')

  if(path[1] == 'questions' && path.length > 2 ){

    consumer.subscriptions.create( 'CommentChannel', {
      connected: function(){
        return this.perform('subscribed', {question_id: path[2] })
      },

      received(data){
        console.log(data.comment.commentable_id)

        if (gon.current_user_id != data.comment.user_id){
          $('.comments-'+ data.comment.commentable_id).append('<p>' + data.comment.body + '</p><hr>')
        }
      }
    })
  }
})
