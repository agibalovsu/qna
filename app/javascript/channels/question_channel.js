import consumer from "./consumer"

$(document).on('turbo:load', function(){

  if($('.questions'>=1)) {
    consumer.subscriptions.create('QuestionChannel',{
      received(data){
        var result = this.createTemplate(data)
        $('.questions').append(result)
      },

      createTemplate(data){
        return `
        <div class="question-${data.question.id}">
          <h5 class="card-title">
            <a href="/questions/${data.question.id}">${data.question.title}</a>
          </h5>
          <div class="card-text">
            ${data.question.body}
          </div>
          <p> Rating </p>        
          <p> Answers </p>    
          <div class="card-footer">
            ${data.created} ${data.user}
          </div>  
        </div>
        `
      }
    })
  }
})
