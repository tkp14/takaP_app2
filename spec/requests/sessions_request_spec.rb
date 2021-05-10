require 'rails_helper'

RSpec.describe "ログイン機能", type: :request do
  let!(:user) { create(:user) }

  describe "ログインページ" do
    it "正常なレスポンスを返すこと" do
      get login_path
      expect(response).to be_success
      expect(response).to have_http_status "200"
    end

    it "有効なユーザーでログイン&ログアウト" do
      get login_path
      post login_path, params: { session: { email: user.email,
                                            password: user.password } }
      redirect_to root_url
      follow_redirect!
      expect(is_logged_in?).to be_truthy  #ログインしている状態を確認
      delete logout_path
      expect(is_logged_in?).not_to be_truthy  #ログインしていない状態を確認
      redirect_to root_url
      delete logout_path
      follow_redirect!
    end

    it "無効なユーザーでログイン" do
      get login_path
      post login_path, params: { session: { email: "user@example.com",
                                           password: "pass" } }
      expect(is_logged_in?).not_to be_truthy
    end
  end
end
