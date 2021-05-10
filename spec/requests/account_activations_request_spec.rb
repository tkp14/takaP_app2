require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  let(:user) { FactoryBot.create(:user, :no_activated) }

  # 正しいトークンと間違ったemailの場合
  context '正しいトークンと間違ったemailの場合' do
    before do
      get edit_account_activation_path(
        user.activation_token,
        email: 'wrong',
      )
    end

    it "ログインできない" do
      expect(is_logged_in?).to be_falsy
      expect(response).to redirect_to root_url
    end
  end

  # 間違ったトークンと正しいemailの場合
  context '間違ったトークンと正しいemailの場合' do
    before do
      get edit_account_activation_path(
        'wrong',
        email: user.email,
      )
    end

    it "ログインできない" do
      expect(is_logged_in?).to be_falsy
      expect(response).to redirect_to root_url
    end
  end

  # トークン、emailが両方正しい場合
  context 'トークン、emailが両方正しい場合' do
    before do
      get edit_account_activation_path(
        user.activation_token,
        email: user.email,
      )
    end

    it "ログインできる" do
      expect(is_logged_in?).to be_truthy
      expect(response).to redirect_to user
    end
  end
end
