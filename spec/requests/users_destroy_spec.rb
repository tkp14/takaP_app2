require "rails_helper"

RSpec.describe "ユーザーの削除", type: :request do
  let!(:admin_user) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:micropost) { create(:micropost, user_id: user.id) }

  context "管理者ユーザーの場合" do
    before do
      login_for_request(admin_user)
      get users_path
    end

    it "ユーザーを削除後、ユーザー一覧ページにリダイレクト" do
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)
      redirect_to users_url
      follow_redirect!
      expect(response).to render_template('users/index')
    end

    it "ユーザーを削除した場合、紐づいたポストも消えること" do
      expect {
        delete user_path(user)
      }.to change(Micropost, :count).by(-1)
      redirect_to users_url
      follow_redirect!
      expect(response).to render_template('users/index')
    end
  end

  context "管理者ユーザーではない場合" do
    before do
      login_for_request(user)
      get users_path
    end

    # it "自分のアカウントは削除できること" do
    #   expect {
    #     delete user_path(user)
    #   }.to change(User, :count).by(-1)
    #   redirect_to root_url
    #   follow_redirect!
    #   expect(response).to render_template('home')
    # end

    # it "紐づいたポストも消えること" do
    #   expect {
    #     delete user_path(user)
    #   }.to change(Micropost, :count).by(-1)
    #   redirect_to root_url
    #   follow_redirect!
    #   expect(response).to render_template('home')
    # end

    it "他人のアカウントは消せないこと" do
      expect {
        delete user_path(other_user)
      }.not_to change(User, :count)
      redirect_to root_url
    end
  end
end
