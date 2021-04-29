require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "トップページ" do
    context "ページ全体" do
      before do
        visit root_path
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

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
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
