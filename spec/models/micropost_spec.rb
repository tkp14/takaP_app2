require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let!(:micropost_yesterday) { create(:micropost, :yesterday) }
  let!(:micropost_one_week_ago) { create(:micropost, :one_week_ago) }
  let!(:micropost_one_month_ago) { create(:micropost, :one_month_ago) }
  let!(:micropost) { create(:micropost) }

  context "バリデーション" do
    it "有効なこと" do
      expect(micropost).to be_valid
    end

    it "user_idがnilの場合エラーになること" do
      micropost.user_id = nil
      expect(micropost).to be_invalid
    end

    it "テキストが140文字以内であること" do
      micropost = build(:micropost, content: "a" * 141)
      micropost.valid?
      expect(micropost.errors[:content]).to include("は140文字以内で入力してください")
    end

    it "テキストが空の場合は無効であること" do
      micropost = build(:micropost, content: "")
      micropost.valid?
      expect(micropost.errors[:content]).to include("を入力してください")
    end
  end

  context "並び順" do
    it "降順であること" do
       expect(micropost).to eq Micropost.first
    end
  end
end
