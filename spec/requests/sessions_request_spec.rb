require 'rails_helper'

RSpec.describe "ログイン機能", type: :request do

  describe "ログインページ" do
    it "正常なレスポンスを返すこと" do
      get login_path
      expect(response).to be_success
      expect(response).to have_http_status "200"
    end
  end
end
