require 'sphinx_helper'

RSpec.describe SearchesController, type: :controller do
	let(:user) { create(:user) }
  let!(:questions) { create_list(:question, 3, user: user) }
  let!(:query)     { 'Question' }
  let!(:resource)  { 'question' }

  describe 'GET#search' do
    context 'for current resource' do
      before do
        ThinkingSphinx::Test.run do
          get :search, params: { query: query, resource: resource}
        end
      end

      it 'status 2xx' do
        expect(response).to be_successful
      end

      it 'renders search view' do
        expect(response).to render_template :search
      end

      it 'assigns @query' do
        expect(assigns(:query)).to eq query
      end

      it 'assigns @resource' do
        expect(assigns(:resource)).to eq resource
      end

      it 'assigns @search_result' do 
        expect(assigns(:search_result)).to match_array(questions) if query == nil
      end
    end

    context 'for all' do
    	let!(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'serch engine responds for all' do
        ThinkingSphinx::Test.run do
          allow(ThinkingSphinx).to receive(:search).with(query)
          get :search, params: { query: query, resource: 'all' }
        end
      end

      it 'serch engine responds for all and return data' do
        ThinkingSphinx::Test.run do
          allow(ThinkingSphinx).to receive(:search).with('Answer').and_return(answer)
          get :search, params: { query: 'Answer', resource: 'all' }
        end
      end
    end
  end
end
	
