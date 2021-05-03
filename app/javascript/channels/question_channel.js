import consumer from "./consumer"
import { ratingLinks, proLinks, conLinks } from '../packs/utilities/rating'
document.addEventListener('turbolinks:load', function () {
  
  consumer.subscriptions.create("QuestionChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log('Hello from cabel')
      let question = document.querySelector('.question')

      if (question) {
        let reg = /^(question-)(\d+)$/
        let id = reg.exec(question.id)[2]
        this.perform('follow_question', {question_id:id })
      }
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      console.log('received')
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
  });
})