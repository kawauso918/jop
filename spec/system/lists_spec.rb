require 'rails_helper'

describe 'TOPページのテスト' do
  let!(:top) { create(:top, name:'hoge', caption:'body') }
  describe 'トップ画面(top_path)のテスト' do
    before do
      visit top_path
    end
    context '表示の確認' do
      it 'TOP画面(top_path)に「写真で繋がろう」が表示されているか' do
        expect(page).to have_content '写真で繋がろう'
      end
      it 'top_pathが"/top"であるか' do
        expect(current_path).to eq('/top')
      end
      it 'ログインボタンが表示されているか' do
        expect(page).to have_button 'ログイン'
      end
       it '新規登録ボタンが表示されているか' do
        expect(page).to have_button '新規登録'
      end
    end
  end
end

describe "ユーザー一覧のテスト" do
    before do
      visit users_path
    end
    context '表示の確認' do
      it '投稿されたものが表示されているか' do
        expect(page).to have_content user.name
        expect(page).to have_button 'フォローする'
        expect(page).to have_button 'フォロー外す'
        expect(page).to have_button 'show'
        expect(page).to have_field 'user[name_cont]', with: user.name_cont
      end
    end
  end

  describe 'ユーザー詳細画面のテスト' do
	   before do
	      visit user_path(user)
	   end
	   context '表示の確認' do
	     it '名前が画面に表示されていること' do
	       expect(page).to have_content user.name
	     end
	     it 'プロフィール編集リンクが表示される' do
	       edit_link = find_all('a')[0]
	       expect(edit_link.native.inner_text).to match(/edit/i)
			 end
			  it 'フォローリンクが存在しているか' do
        expect(page).to have_link 'フォロー'
        end
        it 'フォロワーリンクが存在しているか' do
        expect(page).to have_link 'フォロワー'
        end
	   end
	   context 'リンクの遷移先の確認' do
	     it 'Editの遷移先は編集画面か' do
	       edit_link = find_all('a')[0]
	       edit_link.click
	       expect(current_path).to eq('/users/' + book.id.to_s + '/edit')
	     end
	   end
	end

	describe 'ユーザー編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end
    context '表示の確認' do
      it '編集前の名前が表示されている' do
        expect(page).to have_field 'photo_image[name]', with: user.name
      end
      it '変更ボタンが表示される' do
        expect(page).to have_button '変更を保存'
      end
    end
    context '更新処理に関するテスト' do
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'user[name]', with: Faker::Lorem.characters(number:5)
        click_button '変更を保存'
        expect(page).to have_current_path user_path(user)
      end
    end
  end

  describe "投稿新規画面(new_photo_path)のテスト" do
    before do
      visit new_photo_image_path
    end
    context '表示の確認' do
      it 'new_photo_image_pathが"/photo_images/new"であるか' do
        expect(current_path).to eq('/photo_images/new')
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to have_button '投稿'
      end
    end
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'photo_image[name]', with: Faker::Lorem.characters(number:5)
        fill_in 'photo_image[caption]', with: Faker::Lorem.characters(number:20)
        click_button '投稿'
        expect(page).to have_current_path photo_image_path(PhotoImage.last)
      end
    end
  end

  describe "投稿一覧のテスト" do
    before do
      visit photo_images_path
    end
    context '表示の確認' do
      it '投稿されたものが表示されているか' do
        expect(page).to have_link photo_image.name
        expect(page).to have_content photo_image.caption
        expect(page).to have_content photo_image.comments.count
      end
    end
  end

  describe "投稿詳細画面のテスト" do
    before do
      visit photo_image_path(photo_image)
    end
    context '表示の確認' do
      it '削除リンクが存在しているか' do
        expect(page).to have_link '削除'
      end
      it '編集リンクが存在しているか' do
        expect(page).to have_link '編集'
      end
      it '投稿した名前が存在しているか' do
        expect(page).to have_content '写真名'
      end
      it '投稿した説明が存在しているか' do
        expect(page).to have_content '説明'
      end

    end
      it '投稿したコメント数が存在しているか' do
        expect(page).to have_content 'コメント数'
      end
      it 'コメントがフォームに表示されている' do
        expect(page).to have_field 'comment[comment]', with: comment.comment
      end
      it 'コメントするボタンが表示される' do
        expect(page).to have_button 'コメント'
      end

    context 'リンクの遷移先の確認' do
      it '編集の遷移先は編集画面か' do
        edit_link = find_all('a')[3]
        edit_link.click
        expect(current_path).to eq('/photo_image/' + photo_image.id.to_s + '/edit')
      end
    end
    context '投稿削除のテスト' do
      it '投稿の削除' do
        expect{ photo_image.destroy }.to change{ photo_image.count }.by(-1)
      end
    end
  end

  describe '投稿編集画面のテスト' do
    before do
      visit edit_photo_image_path(photo_image)
    end
    context '表示の確認' do
      it '編集前の名前と説明がフォームに表示(セット)されている' do
        expect(page).to have_field 'photo_image[name]', with: photo_image.name
        expect(page).to have_field 'photo_image[caption]', with: photo_image.caption
      end
      it '投稿ボタンが表示される' do
        expect(page).to have_button '投稿'
      end
    end
    context '更新処理に関するテスト' do
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'photo_image[name]', with: Faker::Lorem.characters(number:5)
        fill_in 'photo_image[caption]', with: Faker::Lorem.characters(number:20)
        click_button '投稿'
        expect(page).to have_current_path photo_image_path(photo_image)
      end
    end
  end

  describe "問い合わせ新規画面(new_contact_path)のテスト" do
    before do
      visit new_contact_path
    end
    context '表示の確認' do
      it 'new_contact_pathが"/contacts/new"であるか' do
        expect(current_path).to eq('/contacts/new')
      end
      it 'フォームに表示されている' do
        expect(page).to have_field 'contact[name]', with: contact.name
        expect(page).to have_field 'contact[email]', with: contact.email
        expect(page).to have_field 'contact[phone_number]', with: contact.phone_number
        expect(page).to have_field 'contact[subject]', with: contact.subject
        expect(page).to have_field 'contact[message]', with: contact.message
      end
      it '入力確認画面ボタンが表示されているか' do
        expect(page).to have_button '入力内容確認'
      end
    end
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'contact[name]', with: Faker::Lorem.characters(number:5)
        fill_in 'contact[email]', with: Faker::Lorem.characters(number:20)
        fill_in 'contact[phone_number]', with: Faker::Lorem.characters(number:20)
        fill_in 'contact[subject]', with: Faker::Lorem.characters(number:20)
        fill_in 'contact[message]', with: Faker::Lorem.characters(number:20)
        click_button '入力内容確認'
        expect(page).to have_current_path confirm_path(Contact.last)
      end
    end
  end

  RSpec.describe "favorites", type: :system do
    before do
      @photo_image = FactoryBot.create(:photo_image)
      @photo_image = FactoryBot.create(:photo_image)
    end

    describe '#create,#destroy' do
      it 'ユーザーが他の投稿をいいね、いいね解除できる' do
        # ログインする
        sign_in(@definition.user)

        # 投稿詳細ページに遷移する
        visit  photo_image_path(@photo_image.id)

        # フォームに情報を入力する
        fill_in 'answer_answer', with: @photo_image

        # 回答を送信すると、Answerモデルのカウントが1上がることを確認する
        expect{
          find('input[name="commit"]').click
        }.to change { PhotoImage.count }.by(1)

        # いいねをするボタンを押す
        find('#favorite-btn').click
        expect(page).to have_selector '#liking-btn'
        expect(@photo_image.favorites.count).to eq(1)

        # いいねを解除する
        find('#favorite-btn').click
        expect(page).to have_selector '#nolike-btn'
        expect(@photo_image.favorites.count).to eq(0)
        end
     end
end
