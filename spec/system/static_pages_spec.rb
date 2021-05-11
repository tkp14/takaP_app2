require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  let(:user) { create(:user) }
  let!(:micropost) { create(:micropost, user: user) }

  describe "トップページ" do
    context "ページ全体(ログインしていない場合)" do
      before do
        visit root_path
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end

      it "sample appが表示されてリンクが繋がっていること" do
        expect(page).to have_link "sample app", href: root_path
      end

      it "Homeが表示されてリンクが繋がっていること" do
        expect(page).to have_link "Home", href: root_path
      end

      it "Helpが表示されてリンクが繋がっていること" do
        expect(page).to have_link "Help", href: help_path
      end

      it "Aboutが表示されてリンクが繋がっていること" do
        expect(page).to have_link "About", href: about_path
      end

      it "Contactが表示されてリンクが繋がっていること" do
        expect(page).to have_link "Contact", href: contact_path
      end
    end

    context "ページ全体(ログインしている場合)" do
      before do
        login_for_system(user)
        visit root_path
      end

      # it "ヘッダーが切り替わること"

      #ここはmicropostのシステムテストに書くべきかも
      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end

      it "Micropost Feedの文字が表示されること" do
        expect(page).to have_content 'Micropost Feed'
      end

      it "ポストのFeedとページネーションが表示されること" do
        create_list(:micropost, 31, user: user)
        visit root_path
        expect(page).to have_css "div.pagination"
        User.take(30).each do |m|
          expect(page).to have_link m.name
        end
      end
    end
  end

  describe "ヘルプページ" do
    context "ページ全体" do
      before do
        visit help_path
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end
    end
  end

  describe "アバウトページ" do
    context "ページ全体" do
      before do
        visit about_path
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end
    end
  end

  describe "コンタクトページ" do
    context "ページ全体" do
      before do
        visit contact_path
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end
    end
  end
end
