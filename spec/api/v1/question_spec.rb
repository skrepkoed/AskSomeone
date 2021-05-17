require 'rails_helper'

describe 'Question Api', type: :request do
  let(:headers){ {'ACCEPT'=>'application/json'} }
  let!(:access_token){ create(:access_token) }
  let!(:user){ User.find(access_token.resource_owner_id) }
  let!(:question){ create(:question) }
  let!(:resource){ create(:question, author: user) }
  let(:resource_name){ 'question' }
  describe 'GET api/v1/questions' do
    let(:api_path){  '/api/v1/questions' }
    let(:method){ :get }
    it_behaves_like 'API authorizable'

    context 'authorized' do
      let!(:questions){ create_list(:question, 3) }
      let(:question){ questions.first }
      let(:question_response){ json['questions'].first }
      let!(:answers){ create_list(:answer, 3, question: question) }
      before { get '/api/v1/questions', params: {access_token: access_token.token}, headers: headers }
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq Question.count
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
    let!(:links){ create_list(:link, 2, linkable: resource) }
    let!(:comments){ create_list(:comment, 2, commentable: resource, author:resource.author ) }
    let!(:file){ resource.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }
    let(:api_path){  "/api/v1/questions/#{resource.id}" }
    let(:method){ :get }
    it_behaves_like 'API show'
  end

  describe 'POST api/v1/questions/:question_id/answers' do
    let(:api_path){  "/api/v1/questions" }
    let(:method){ :post }
    it_behaves_like 'API create'
  end

  describe 'PATCH api/v1/questions/:question_id/answers/:id' do
    let(:api_path){ "/api/v1/questions/#{resource.id}" }
    let(:method){ :patch }
    let(:api_path_for_unauthorized_action){  "/api/v1/questions/#{question.id}" }
    it_behaves_like 'API update'
  end

  describe 'DELETE api/v1/questions/:question_id/answers/:id' do
    let(:api_path){  "/api/v1/questions/#{resource.id}" }
    let(:method){ :delete }
    let(:api_path_for_unauthorized_action){ "/api/v1/questions/#{question.id}" }
    it_behaves_like 'API destroy'
  end
end