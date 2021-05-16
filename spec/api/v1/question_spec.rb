require 'rails_helper'

describe 'Profile Api', type: :request do
  describe 'GET api/v1/questions' do
    let(:headers){ {'ACCEPT'=>'application/json'} }
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
        it 'returns list of questions' do
          expect(question_response['answers'].size).to eq answers.size
        end

        it 'returns all public fields' do
          %w[id  body user_id question_id created_at updated_at].each do |attr|
            expect(answers_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end