require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }

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
        login_for_system(user)
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
        login_for_system(user)
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

  describe "ユーザー一覧ページ" do
    context "ページレイアウト" do
      it "正しいタイトルが表示されることを確認" do
        login_for_system(user)
        visit users_path
        expect(page).to have_title full_title('ユーザー一覧')
      end

      it "ユーザー一覧の文字列が表示されていること" do
        login_for_system(user)
        visit users_path
        expect(page).to have_content "ユーザー一覧"
      end

      it "adminユーザーはぺージネーション、削除ボタンが表示されること" do
        create_list(:user, 31)
        login_for_system(admin_user)
        visit users_path
        expect(page).to have_css "div.pagination"
        User.paginate(page: 1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          expect(page).to have_content "#{u.name} | 削除" || "Example User"
        end
      end

      it "adminユーザーではないユーザーは削除ボタンが表示されないこと" do
        create_list(:user, 31)
        login_for_system(user)
        visit users_path
        expect(page).to have_css "div.pagination"
        User.paginate(page: 1).each do |u|
          expect(page).to have_link u.name, href: user_path(u)
          expect(page).not_to have_content "#{u.name} | 削除"
        end
      end
    end

    context "アカウントの削除", js: true do
      it "adminユーザーの場合、ユーザーを正しく削除できること" do
        create_list(:user, 10)
        login_for_system(admin_user)
        visit users_path
        click_on "削除"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "User deleted"
      end
    end
  end
end
