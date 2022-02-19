require 'rails_helper'

RSpec.describe 'photo_imageモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { photo_image.valid? }

    let(:user) { create(:user) }
    let!(:photo_image) { build(:photo_image, user_id: user.id) }

    context 'nameカラム' do
      it '空欄でないこと' do
        photo_image.name = ''
        is_expected.to eq false
      end
    end

    context 'captionカラム' do
      it '空欄でないこと' do
        photo_image.caption = ''
        is_expected.to eq false
      end
      it '200文字以下であること: 200文字は〇' do
        photo_image.caption = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it '200文字以下であること: 201文字は×' do
        photo_image.caption = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(PhotoImage.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end
