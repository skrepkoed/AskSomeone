class QuestionChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def follow_question(data)
    question =  Question.find(data['question_id'])
    stream_for question
  end

  def follow_questions
    stream_from 'questions_list'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
