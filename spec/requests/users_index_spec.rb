require 'rails_helper'

RSpec.describe "プロフィールページ", type: :request do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }

  context "認可されたユーザーの場合" do
    it "正しい画面が表示されること" do
      login_for_request(user)
      get users_path
      expect(response).to be_success
      expect(response).to have_http_status "200"
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ホーム画面へリダイレクトされること" do
      get users_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end

  it "admin属性の変更が禁止されていること" do
    login_for_request(user)
    expect(user.admin).to be_falsey
    patch user_path(user), params: { user: { password: user.password,
                                             password_confirmation: user.password,
                                             admin: true } }
    expect(user.reload.admin).to be_falsey
  end
end
