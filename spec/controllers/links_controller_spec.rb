require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:link) { create(:link, linkable: question) }
  let!(:other_link) { create(:link) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'author of record' do
      it 'delete the link' do
        expect {
          delete :destroy, params: {id: link, format: :js}
        }.to change(Link, :count).by(-1)
      end
      it 'render destroy view' do
        delete :destroy, params: {id: link, format: :js}
        expect(response).to render_template :destroy
      end
    end

    context 'not author of record' do
      it 'no delete the link' do
        expect {
          delete :destroy, params: {id: other_link, format: :js}
        }.to_not change(Link, :count)
      end
      it 'render destroy view' do
        delete :destroy, params: {id: other_link, format: :js}
        expect(response).to render_template :destroy
      end
    end
  end
end
