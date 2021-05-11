require 'rails_helper'

RSpec.describe "Microposts", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe "ポストについて" do
    context "投稿機能" do
      before do
        login_for_system(user)
        visit root_path
      end

      it "正しいデータを投稿すると成功のフラッシュが表示" do
        fill_in "text", with: "Hello"
        click_button "Post"
        expect(page).to have_content "Micropost created!"
      end

      it "無効なデータの場合は失敗のフラッシュ" do
        fill_in "text", with: " "
        click_button "Post"
        expect(page).to have_content "Contentを入力してください"
      end
    end

    context "削除機能", js: true do
      let!(:micropost) { create(:micropost, user: user) }

      before do
        login_for_system(user)
      end

      it "自分のポスト削除後、削除成功のフラッシュが表示されること(home画面)" do
        visit root_path
        click_on 'delete'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'Micropost deleted'
      end

      it "自分のポスト削除後、削除成功のフラッシュが表示されること(Profile画面)" do
        visit users_path
        within find('#delete-post') do
          click_on 'delete'
        end
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'Micropost deleted'
      end

      it "違うユーザのプロフィールにアクセス(削除リンクがないことを確認)" do
        visit users_path(other_user)
        expect(page).not_to have_link "delete"
      end
    end
  end
end
