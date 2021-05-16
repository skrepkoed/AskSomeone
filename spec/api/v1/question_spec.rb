require 'rails_helper'

describe 'Profile Api', type: :request do
  let(:headers){ {'ACCEPT'=>'application/json'} }
  describe 'GET api/v1/questions' do
    let(:api_path){  '/api/v1/questions' }
    let(:method){ :get }
    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token){ create(:access_token) }
      let!(:questions){ create_list(:question, 3) }
      let(:question){ questions.first }
      let(:question_response){ json['questions'].first }
      let!(:answers){ create_list(:answer, 3, question: question) }
      before { get '/api/v1/questions', params: {access_token: access_token.token}, headers: headers }
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq questions.size
      end

      it 'returns all public fields' do
        %w[id title body best_answer created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(5)
      end

      describe 'answers' do
        let(:answer){ answers.first }
        let(:answers_response){ question_response['answers'].first } 
        it 'returns list of anwers' do
          expect(question_response['answers'].size).to eq answers.size
        end

        it 'returns all public fields' do
          %w[id  body created_at updated_at].each do |attr|
            expect(answers_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
  describe 'GET api/v1/questions/:id' do
    let!(:question){ create(:question) }
    let!(:links){ create_list(:link, 2, linkable: question) }
    let!(:comments){ create_list(:comment, 2, commentable: question, author:question.author ) }
    let!(:file){ question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }
    let(:api_path){  "/api/v1/questions/#{question.id}" }
    let(:method){ :get }
    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token){ create(:access_token) }
      let(:question_response){ json['question'] }
      before { get "/api/v1/questions/#{question.id}", params: {access_token: access_token.token}, headers: headers }
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body best_answer created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
        
        expect(question_response['links_url'].first).to eq question.links.first.url
        expect(question_response['comments'].first['body']).to eq question.comments.first.body.as_json
        expect(question_response['files_url'].first).to eq Rails.application.routes.url_helpers.rails_blob_path(question.files.first, only_path: true) 
      end
    end
  end

  describe 'GET api/v1/questions/:id/answers' do
    let!(:question){ create(:question) }
    let!(:answers){ create_list(:answer, 3, question: question, author: question.author) }
    let!(:answer){ answers.first }
    let(:api_path){  "/api/v1/questions/#{question.id}/answers" }
    let(:method){ :get }
    it_behaves_like 'API authorizable'

    before { get "/api/v1/questions/#{question.id}/answers", params: {access_token: access_token.token}, headers: headers }

    context 'authorized' do
      let(:access_token){ create(:access_token) }
      let(:answer_response){ json['answers'].first }
      
      before { get "/api/v1/questions/#{question.id}/answers", params: {access_token: access_token.token}, headers: headers }
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of question answers' do
        expect(json['answers'].size).to eq answers.count
      end

      it 'returns all public fields' do
        %w[id  body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['author']['id']).to eq answers.first.author.id
      end
    end
  end
end