require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:other_question) { create(:question) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'author of record' do
      before do
        question.files.attach(create_file_blob)
      end

      it 'delete the file' do
        expect {
          delete :destroy, params: {id: question.files.first, format: :js}
        }.to change(question.files, :count).by(-1)
      end
      it 'render destroy view' do
        delete :destroy, params: {id: question.files.first, format: :js}
        expect(response).to render_template :destroy
      end
    end

    context 'not author of record' do
      before do
        other_question.files.attach(create_file_blob)
      end

      it 'no delete the file' do
        expect {
          delete :destroy, params: {id: other_question.files.first, format: :js}
        }.to_not change(other_question.files, :count)
      end
      it 'return forbidden status' do
        delete :destroy, params: {id: other_question.files.first, format: :js}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
