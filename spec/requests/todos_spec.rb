require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  describe 'unauthenticated access' do
    describe 'GET /todos' do
      it 'redirects to login page' do
        get '/todos'
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'authenticated access' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    describe 'GET /todos' do
      it 'returns 200' do
        get '/todos'
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET /todos/new' do
      it 'returns 200' do
        get '/todos/new'
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /todos' do
      context 'with valid parameters' do
        let(:valid_params) do
          {
            todo: {
              title: 'Test Todo',
              description: 'Test Description'
            }
          }
        end

        it 'creates a new Todo' do
          expect {
            post '/todos', params: valid_params
          }.to change(Todo, :count).by(1)
        end

        it 'redirects to todos path' do
          post '/todos', params: valid_params
          expect(response).to redirect_to(todos_path)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) do
          {
            todo: {
              title: '',
              description: 'Test Description'
            }
          }
        end

        it 'does not create a Todo' do
          expect {
            post '/todos', params: invalid_params
          }.not_to change(Todo, :count)
        end

        it 'returns 422' do
          post '/todos', params: invalid_params
          expect(response).to have_http_status(422)
        end
      end
    end

    describe 'PATCH /todos/:id' do
      let(:todo) { create(:todo, user: user) }

      context 'with valid parameters' do
        let(:new_attributes) do
          {
            todo: {
              title: 'Updated Title'
            }
          }
        end

        it 'updates the Todo' do
          patch "/todos/#{todo.id}", params: new_attributes
          todo.reload
          expect(todo.title).to eq('Updated Title')
        end

        it 'redirects to todos path' do
          patch "/todos/#{todo.id}", params: new_attributes
          expect(response).to redirect_to(todos_path)
        end
      end

      context 'with another user\'s Todo' do
        let(:other_user) { create(:user) }
        let(:other_todo) { create(:todo, user: other_user) }
        let(:new_attributes) do
          {
            todo: {
              title: 'Hacked Title'
            }
          }
        end

        it 'does not update the Todo' do
          patch "/todos/#{other_todo.id}", params: new_attributes
          other_todo.reload
          expect(other_todo.title).not_to eq('Hacked Title')
        end

        it 'returns 404' do
          patch "/todos/#{other_todo.id}", params: new_attributes
          expect(response).to have_http_status(404)
        end
      end
    end

    describe 'DELETE /todos/:id' do
      let(:todo) { create(:todo, user: user) }

      it 'deletes the Todo' do
        todo_id = todo.id
        expect {
          delete "/todos/#{todo_id}"
        }.to change(Todo, :count).by(-1)
      end

      it 'redirects to todos path' do
        delete "/todos/#{todo.id}"
        expect(response).to redirect_to(todos_path)
      end

      context 'with another user\'s Todo' do
        let(:other_user) { create(:user) }
        let(:other_todo) { create(:todo, user: other_user) }

        it 'does not delete the Todo' do
          other_todo_id = other_todo.id
          expect {
            delete "/todos/#{other_todo_id}"
          }.not_to change(Todo, :count)
        end

        it 'returns 404' do
          delete "/todos/#{other_todo.id}"
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
