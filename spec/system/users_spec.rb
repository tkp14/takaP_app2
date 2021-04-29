require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "ユーザー登録ページ" do
    context "ページ全体" do
      before do
        visit signup_path
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end
    end
  end
end
