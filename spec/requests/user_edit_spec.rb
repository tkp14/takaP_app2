require 'rails_helper'

RSpec.describe "プロフィールページ", type: :request do
  let!(:user) { create(:user) }

  before do
    get edit_user_path(user)
  end

  it "有効なデータで更新を行うと正常に更新されること" do
    expect(response).to render_template('users/edit')
    patch user_path(user), params: { user: { name: "Example",
                                             email: "user@example.com" } }
    redirect_to @user
    follow_redirect!
    expect(response).to render_template('users/show')
  end

  it "無効なデータで更新を行うとエラーが起きること" do
    expect(response).to render_template('users/edit')
    patch user_path(user), params: { user: { name: "",
                                     email: "user@example.com" } }
    expect(response).to render_template('users/edit')
  end
end
