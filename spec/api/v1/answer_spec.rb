require 'rails_helper'

describe 'Answer Api', type: :request do
  let(:headers){ {'ACCEPT'=>'application/json'} }
  let!(:access_token){ create(:access_token) }
  let!(:user){ User.find(access_token.resource_owner_id) }
  let!(:question){ create(:question) }
  let!(:resource){ create(:answer, question: question, author: user) }
  let(:resource_name){ 'answer' }

  describe 'GET api/v1/questions/:id/answers' do
    let!(:resource_collection){ create_list(:answer, 3, question: question, author: question.author) }
    let(:resource){ resource_collection.first }
    let(:api_path){  "/api/v1/questions/#{question.id}/answers" }
    let(:method){ :get }
    it_behaves_like 'API CRUD operations'
  end

  describe 'GET api/v1/questions/:question_id/answers/:id' do
    let!(:links){ create_list(:link, 2, linkable: resource) }
    let!(:comments){ create_list(:comment, 2, commentable: resource, author:question.author ) }
    let!(:file){ resource.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }
    let(:api_path){  "/api/v1/questions/#{question.id}/answers/#{resource.id}" }
    let(:method){ :get }
    it_behaves_like 'API show'
  end

  describe 'POST api/v1/questions/:question_id/answers' do
    let(:api_path){  "/api/v1/questions/#{question.id}/answers" }
    let(:method){ :post }
    it_behaves_like 'API create'
  end

  describe 'PATCH api/v1/questions/:question_id/answers/:id' do
    let(:api_path){ "/api/v1/questions/#{question.id}/answers/#{resource.id}" }
    let(:method){ :patch }
    let!(:answer){ create(:answer, question: question) }
    let(:api_path_for_unauthorized_action){  "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    it_behaves_like 'API update'
  end

  describe 'DELETE api/v1/questions/:question_id/answers/:id' do
    let(:api_path){  "/api/v1/questions/#{question.id}/answers/#{resource.id}" }
    let(:method){ :delete }
    let!(:answer){ create(:answer, question: question) }
    let(:api_path_for_unauthorized_action){  "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    it_behaves_like 'API destroy'
  end
end