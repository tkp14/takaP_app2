require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  describe "ログインについて" do
    let!(:user) { create(:user) }

    before do
      visit login_path
    end

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
        expect(page).to have_css 'input.form-control'
        expect(page).to have_css 'input.form-control'
      end

      it "チェックボックスが表示されていること" do
        expect(page).to have_content 'Remember me on this computer'
        expect(page).to have_css 'input#session_remember_me'
      end

      it "ログインボタンが表示されていること" do
        expect(page).to have_button 'ログイン'
      end
    end

    context "ログイン処理" do
      it "無効なユーザーの場合はログインが失敗すること" do
        fill_in "user_email", with: user.email
        fill_in "user_password", with: "pass"
        click_button 'ログイン'
        expect(page).to have_content 'Invalid email/password combination'

        visit root_path
        expect(page).not_to have_content 'Invalid email/password combination'
      end

      it "有効なユーザーの場合はログインが成功し、ヘッダーメニューが変わること" do
        expect(page).to have_link 'Home', href: root_path
        expect(page).to have_link 'Help', href: help_path
        expect(page).to have_link 'About', href: about_path
        expect(page).to have_link 'Contact', href: contact_path
        expect(page).to have_link 'Log in', href: login_path

        fill_in "user_email", with: user.email
        fill_in "user_password", with: user.password
        click_button 'ログイン'

        expect(page).to have_link 'Home', href: root_path
        expect(page).to have_link 'Help', href: help_path
        expect(page).to have_link 'About', href: about_path
        expect(page).to have_link 'Users', href: root_path

       # expect(page).to have_link 'Profile', href: current_user

        expect(page).to have_link 'Log out', href: logout_path
      end
    end
  end
end
