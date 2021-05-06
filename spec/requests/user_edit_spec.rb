require 'rails_helper'

RSpec.describe "プロフィールページ", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  context "ログインユーザーの場合" do

    it "レスポンスが正常に表示されること(+フレンドリーフォワーディング)" do
      get edit_user_path(user)
      login_for_request(user)
      expect(response).to redirect_to edit_user_url(user)
      patch user_path(user), params: { user: { name: "Example",
                                              email: "user@example.com" } }
      redirect_to @user
      follow_redirect!
      expect(response).to render_template('users/show')
    end

    it "無効なデータで更新を行うとエラーが起きること" do
      login_for_request(user)
      get edit_user_path(user)
      expect(response).to render_template('users/edit')
      patch user_path(user), params: { user: { name: "",
                                      email: "user@example.com" } }
      expect(response).to render_template('users/edit')
    end
  end

  context "ログインユーザーではない場合" do
    before do
      login_for_request(other_user)
    end

    it "ホーム画面にリダイレクトすること" do
      #編集
      get edit_user_path(user)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
      #更新
      patch user_path(user), params: { user: { name: user.name,
                                               email: user.email } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログインページへリダイレクトされること" do
      #編集
      get edit_user_path(user)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
      #更新
      patch user_path(user), params: { user: { name: user.name,
                                               email: user.email } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
