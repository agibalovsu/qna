import consumer from "./consumer"

$(document).on('turbo:load', function(){
  var path = $(location).attr('pathname').split('/')

  if(path[1] == 'questions' && path.length > 2 ) {

    consumer.subscriptions.create({channel: 'AnswerChannel', question: path[2]},{
      received(data){

        if (gon.current_user_id != data.answer.user_id){
          var result = this.createTemplate(data)
          $('.answers').append(result)
        }
      },

      createTemplate(data){
        var links = ''

        $.each(data.links, function(index, value) {
          links += `<p><a href = ${value.url}> ${value.name} </a></p>`
        })

        var comments = `
          <div class="comments-${data.answer.id}">
            <div>
              <a class="add-comment-link" id="${data.answer.id}" data-commentable-id="${data.answer.id}" href="#">
                Add comment
              </a>
            </div>
            <div class="comments-form-${data.answer.id} d-none">
              <form class="new_comment" id="add-comment-${data.answer.id}" action="/answers/${data.answer.id}/comments" accept-charset="UTF-8" data-remote="true" method="post">
                <label class= for="comment_body">Body</label>
                  <div>
                    <textarea class="form-control" name="comment[body]" id="comment_body"></textarea>
                  </div>
                <input type="submit" name="commit" value="Create comment" data-disable-with="Create comment">
              </form>
            </div>
          </div>
        `

        var result =  `
        <div class="answer-${data.answer.id}">
          <div>
            answered: ${data.date} ${data.user}
            <div class="vote">
              <div class="vote-answer-${data.answer.id} text-center">
                <div class="rating-answer-${data.answer.id}">    
                  <h1 class="text-center">
                    <span class="badge bg-secondary text-white"> 0 </span>
                  </h1>
                </div>
              </div>
            </div>
          </div>
          <div>
            ${data.answer.body}
          </div>
          <div class="card-text">
            ${links}
          </div>
          ${comments} 
        </div>
        `
        return result
      }
    })
  }
})