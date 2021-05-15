require 'rails_helper'

RSpec.describe "Relationships", type: :system do
  let!(:user) { create(:user) }
  let!(:micropost) { create(:micropost, user: user) }
  let!(:other_user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:user4) { create(:user) }

  describe "フォロー中(following一覧)ページ" do
    before do
      create(:relationship, follower_id: user.id, followed_id: user2.id)
      create(:relationship, follower_id: user.id, followed_id: user3.id)
      login_for_system(user)
      visit following_user_path(user)
    end

    context "ページレイアウト" do
      it "正しいタイトル、「Following」の文字が存在すること" do
        expect(page).to have_content "Following"
        expect(page).to have_title full_title("Following")
      end

      it "ユーザー情報が表示されていること" do
        expect(page).to have_content user.name
        expect(page).to have_link "view my profile", href: user_path(user)
        expect(page).to have_content "Microposts: #{user.microposts.count}"
        expect(page).to have_link "#{user.following.count}", href: following_user_path(user)
        expect(page).to have_link "#{user.followers.count}", href: followers_user_path(user)
      end

      it "フォロー中のユーザーが表示されていること" do
        within find('.users') do
          expect(page).to have_css 'li', count: user.following.count
          user.following.each do |u|
            expect(page).to have_link u.name, href: user_path(u)
          end
        end
      end
    end
  end

  describe "フォロワー(followers一覧)ページ" do
    before do
      create(:relationship, follower_id: user.id, followed_id: user2.id)
      create(:relationship, follower_id: user.id, followed_id: user3.id)
      create(:relationship, follower_id: user4.id, followed_id: user.id)
      login_for_system(user)
      visit followers_user_path(user)
    end

    context "ページレイアウト" do
      it "正しいタイトル、「Followers」の文字が存在すること" do
        expect(page).to have_content "Followers"
        expect(page).to have_title full_title('Followers')
      end

      it "ユーザー情報が表示されていること" do
        expect(page).to have_content user.name
        expect(page).to have_link "view my profile", href: user_path(user)
        expect(page).to have_content "Microposts: #{user.microposts.count}"
        expect(page).to have_link "#{user.following.count}", href: following_user_path(user)
        expect(page).to have_link "#{user.followers.count}", href: followers_user_path(user)
      end

      it "フォロワーのユーザーが表示されていること" do
        within find('.users') do
          expect(page).to have_css 'li', count: user.followers.count
          user.followers.each do |u|
            expect(page).to have_link u.name, href: user_path(u)
          end
        end
      end
    end
  end
end
