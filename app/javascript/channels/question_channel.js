import consumer from "./consumer"
import { ratingLinks, proLinks, conLinks } from '../packs/utilities/rating'
document.addEventListener('turbolinks:load', function () {
  
  consumer.subscriptions.create("QuestionChannel", {
    connected() {
      console.log('connected')
      // Called when the subscription is ready for use on the server
      let question = document.querySelector('.question')
      console.log(question)
      if (question) {
        let reg = /^(question-)(\d+)$/
        let id = reg.exec(question.id)[2]
        this.perform('follow_question', {question_id:id })
        console.log(id)
      }
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      console.log('recieved')
      if (data.commentable_id) {
        
        if (data.type == 'Question') {
          let question_id = '#question-'+data.commentable_id
          let question = $(question_id+' .comments').append(data.comment_partial)
          $(question_id+ ' .comments_container form').find("input[type=text], textarea").val("")
        }

        if (data.type == 'Answer') {
          let answer_id = '#answer-'+data.commentable_id
          let answer = $(answer_id+' .comments').append(data.comment_partial)
          $(answer_id+ ' .comments_container form').find("input[type=text], textarea").val("")
        }
      }

      if(data.id){
        let answers = $('.answers')
        if (gon.user == data.id){
          answers.append(data.for_current_user)
        }else{
          answers.append(data.for_users)
          let last_answer = document.querySelector('.answers').lastChild
          let proLink =  last_answer.getElementsByClassName('rating-link-pro')[0]
          let conLink =  last_answer.getElementsByClassName('rating-link-con')[0]
          proLinks(proLink)
          conLinks(conLink)
          ratingLinks(proLink)
          ratingLinks(conLink)
        }
      }
      
    }
  });
})