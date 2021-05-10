require 'rails_helper'

RSpec.describe "ユーザー登録ページ", type: :request do

  before do
    get signup_path
  end

  it "正常なレスポンスを返すこと" do
    expect(response).to be_success
    expect(response).to have_http_status "200"
  end

  it "有効なユーザーで登録" do
    expect {
      post users_path, params: { user: { name: "Example User",
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "password" } }
    }.to change(User, :count).by(1)
    expect(ActionMailer::Base.deliveries.size).to eq(1)
    expect(response).to redirect_to root_url
    expect(is_logged_in?).to be_falsy
    # expect(response).to render_template('users/show')
    # expect(is_logged_in?).to be_truthy
  end

  it "無効なユーザーで登録" do
    expect {
      post users_path, params: { user: { name: "",
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "pass" } }
    }.not_to change(User, :count)
    expect(is_logged_in?).not_to be_truthy
  end
end
