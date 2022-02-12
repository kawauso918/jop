# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhotoImage, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
	    it "有効な投稿内容の場合は保存されるか" do
	      expect(FactoryBot.build(:photo_image)).to be_valid
	    end
	  end
	  context "空白のバリデーションチェック" do
	    it "titleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
	      photo_image = PhotoImage.new(name: '', caption:'hoge')
	      expect(photo_image).to be_invalid
	      expect(photo_image.errors[:name]).to include("can't be blank")
	    end
	    it "bodyが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
	      photo_image = PhotoImage.new(name: 'hoge', caption:'')
	      expect(photo_image).to be_invalid
	      expect(photo_image.errors[:caption]).to include("can't be blank")
	    end
	  end
	end