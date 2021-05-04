require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe "ユーザー登録ページ" do
    before do
      visit signup_path
    end

    context "ページレイアウト" do
      it "「Sign up」の文字列が存在することを確認" do
        expect(page).to have_content 'Sign up'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('Sign up')
      end
    end

    context "ユーザー登録処理" do
      it "有効なユーザーでユーザー登録を行うとユーザー登録成功のフラッシュが表示されること" do
        fill_in "ユーザー名", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "foobar"
        fill_in "パスワード(確認)", with: "foobar"
        click_button 'Create my account'
        expect(page).to have_content "Welcome to the Sample App!"
      end

      it "無効なユーザーでユーザー登録を行うと登録失敗のフラッシュが表示されること" do
        fill_in "ユーザー名", with: ""
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "foobar"
        fill_in "パスワード(確認)", with: "foobar"
        click_button 'Create my account'
        expect(page).to have_content "ユーザー名を入力してください"
      end
    end
  end

  describe "プロフィールページ" do
    context "ページレイアウト" do
      before do
        visit user_path(user)
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title(user.name)
      end

      it "ユーザー情報が表示されることを確認" do
        expect(page).to have_content user.name
      end
    end
  end

  describe "プロフィール編集ページ" do
    context "ページレイアウト" do
      before do
        visit edit_user_path(user)
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('Edit')
      end

      it "更新ページの文字列が表示されていること" do
        expect(page).to have_content "編集ページ"
      end

      it "有効なプロフィール更新を行うと、更新成功のフラッシュが表示されること" do
        fill_in "ユーザー名", with: "Example"
        fill_in "メールアドレス", with: "use@example.com"
        click_button '更新する'
        expect(page).to have_content "Profile updated"
        expect(user.reload.name).to eq "Example"
        expect(user.reload.email).to eq "use@example.com"
      end

      it "無効なプロフィール更新をしようとすると、適切なエラーメッセージが表示されること" do
        fill_in "ユーザー名", with: ""
        fill_in "メールアドレス", with: "user@example.com"
        click_button '更新する'
        expect(page).to have_content 'ユーザー名を入力してください'
      end
    end
  end
end
