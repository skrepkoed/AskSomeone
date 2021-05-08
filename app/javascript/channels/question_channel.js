import consumer from "./consumer"
import { ratingLinks, proLinks, conLinks } from '../packs/utilities/rating'
document.addEventListener('turbolinks:load', function () {
  
  consumer.subscriptions.create("QuestionChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
      let question = document.querySelector('.question')
      let questions = document.querySelector('.questions')
      
      if (question) {
        let reg = /^(question-)(\d+)$/
        let id = reg.exec(question.id)[2]
        this.perform('follow_question', { question_id:id })
      }

      if (questions) {
        this.perform('follow_questions')
      }
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      if (data.commentable_id) {
        appendComment(data)
      }

      if(data.id && gon.user != data.id){
        appendAnswer(data)
      }
      
      if (data.question_item_partial) {
        appendQuestion(data)
      } 
    }
  })
})

function appendComment(data){
  let resource_type = data.type.toLowerCase()
  let resource_id = '#' + resource_type +'-'+data.commentable_id
  let resource = $(resource_id+' .comments').append(data.comment_partial)
        
  $(resource_id+ ' .comments_container form').find("input[type=text], textarea").val("")
}

function appendAnswer(data){
  let answers = $('.answers')
  answers.append(data.for_users)
  let last_answer = document.querySelector('.answers').lastChild
  let proLink =  last_answer.getElementsByClassName('rating-link-pro')[0]
  let conLink =  last_answer.getElementsByClassName('rating-link-con')[0]
  proLinks(proLink)
  conLinks(conLink)
  ratingLinks(proLink)
  ratingLinks(conLink)
}

function appendQuestion(data){
  $('.questions').append(data.question_item_partial)
}