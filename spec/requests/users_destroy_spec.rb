require "rails_helper"

RSpec.describe "ユーザーの削除", type: :request do
  let!(:admin_user) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  context "管理者ユーザーの場合" do
    it "ユーザーを削除後、ユーザー一覧ページにリダイレクト" do
      login_for_request(admin_user)
      get users_path
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)
      redirect_to users_url
      follow_redirect!
      expect(response).to render_template('users/index')
    end
  end
end
  # context "管理者ユーザーではない場合" do
  #   it "自分のアカウントを削除できること" do
  #     login_for_request(user)
  #     get users_path

  #   end
  # end
