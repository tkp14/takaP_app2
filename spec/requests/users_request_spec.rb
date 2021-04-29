require 'rails_helper'

RSpec.describe "Usersページ", type: :request do

  describe "ユーザー登録ページ" do
    it "正常なレスポンスを返すこと" do
      get signup_path
      expect(response).to be_success
      expect(response).to have_http_status "200"
    end
  end
end
