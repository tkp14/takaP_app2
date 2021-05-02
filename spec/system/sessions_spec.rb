require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let!(:user) { create(:user) }

  before do
    visit login_path
  end

  describe "ログインページ" do
    context "ページレイアウト" do
      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('Login')
      end

      it "ログインページが表示されていること" do
        expect(page).to have_content 'ログインページ'
      end

      it "ログインフォームのラベルが正しく表示される" do
        expect(page).to have_content 'メールアドレス'
        expect(page).to have_content 'パスワード'
      end

      it "ログインフォームが正しく表示される" do
        expect(page).to have_css 'input#user_email'
        expect(page).to have_css 'input#user_password'
      end

      it "ログインボタンが表示されていること" do
        expect(page).to have_button 'ログイン'
      end
    end

    context "ログイン処理" do
      it "無効なユーザーの場合はログインが失敗すること" do
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "foo"
        click_button 'ログイン'
        expect(page).to have_content 'Invalid email/password combination'

        visit root_path
        expect(page).not_to have_content 'Invalid email/password combination'
      end
    end
  end
end
