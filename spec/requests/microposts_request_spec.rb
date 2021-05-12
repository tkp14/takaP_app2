require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:micropost) { create(:micropost, user: user) }
  let(:picture_path) { File.join(Rails.root, 'spec/fixtures/test_default.png') }
  let(:picture) { Rack::Test::UploadedFile.new(picture_path) }

  describe "ポストについて" do
    context "投稿処理" do
      before do
        login_for_request(user)
        get root_path
      end

      it "レスポンスが正常に表示されること" do
        expect(response).to have_http_status "200"
        expect(response).to render_template('home')
      end

      it "有効なデータで投稿できること" do
        expect {
          post microposts_path, params: { micropost: { content: "Hello",
                                                       picture: picture } }
        }.to change(Micropost, :count).by(1)
        follow_redirect!
        expect(response).to render_template('home')
      end

      it "無効なデータで投稿できること" do
        expect {
          post microposts_path, params: { micropost: { content: " ",
                                                       picture: picture } }
        }.not_to change(Micropost, :count)
        expect(response).to render_template('home')
      end
    end

    context "削除処理" do
      before do
        login_for_request(user)
      end

      it "ログインユーザー自身のポストは削除できること" do
        expect {
          delete micropost_path(user)
        }.to change(Micropost, :count).by(0)
        redirect_to root_url
        follow_redirect!
        expect(response).to render_template('home')
      end

      it "他のユーザーのポストは削除できずリダイレクトされること" do
        expect {
          delete micropost_path(other_user)
        }.not_to change(Micropost, :count)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
      end
    end
  end
end
