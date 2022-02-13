require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:photo_image) { create(:photo_image, user: user) }
  let!(:other_photo_image) { create(:photo_image, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it 'ユーザー一覧を押すと、ユーザ一覧画面に遷移する' do
        users_link = find_all('a')[1].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link
        is_expected.to eq '/users'
      end
      it '投稿一覧を押すと、投稿一覧画面に遷移する' do
        photo_images_link = find_all('a')[2].native.inner_text
        photo_images_link = photo_images_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link photo_images_link
        is_expected.to eq '/photo_images'
      end
      it '投稿フォームを押すと、投稿フォーム画面に遷移する' do
        new_photo_image_link = find_all('a')[3].native.inner_text
        new_photo_image_link = new_photo_image_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link new_photo_image_link
        is_expected.to eq '/photo_images/new'
      end
      it 'プロフィールを押すと、自分のユーザ詳細画面に遷移する' do
        _link = find_all('a')[4].native.inner_text
        home_link = home_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link home_link
        is_expected.to eq '/users/' + user.id.to_s
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit photo_images_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/photo_images'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(photo_image.user)
        expect(page).to have_link '', href: user_path(other_photo_image.user)
      end
      it '自分の投稿と他人の投稿した写真の名前のリンク先がそれぞれ正しい' do
        expect(page).to have_link photo_image.name, href: photo_image_path(photo_image)
        expect(page).to have_link other_photo_image.name, href: photo_image_path(other_photo_image)
      end
      it '自分の投稿と他人の投稿の説明が表示される' do
        expect(page).to have_content photo_image.caption
        expect(page).to have_content other_photo_image.caption
      end
    end

  end

  describe "投稿新規画面(new_photo_image_path)のテスト" do
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
    context '投稿成功のテスト' do
      before do
        fill_in 'photo_image[name]', with: Faker::Lorem.characters(number: 5)
        fill_in 'photo_image[caption]', with: Faker::Lorem.characters(number: 20)
      end
      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '投稿' }.to change(user.photo_images, :count).by(1)
      end
      it 'リダイレクト先が、保存できた投稿の投稿一覧画面になっている' do
        click_button '投稿'
        expect(current_path).to eq '/photo_images/' + PhotoImage.last.id.to_s
      end
    end
  end


  describe '自分の投稿詳細画面のテスト' do
    before do
      visit photo_image_path(photo_image)
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/photo_image/' + photo_image.id.to_s
      end
     it '投稿した名前が存在しているか' do
        expect(page).to have_content 'name'
      end
      it '投稿した説明が存在しているか' do
        expect(page).to have_content 'caption'
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link '編集', href: edit_photo_image_path(photo_image)
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '削除', href: photo_image_path(photo_image)
      end
    end
    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link '編集'
        expect(current_path).to eq '/photo_image/' + book.id.to_s + '/edit'
      end
    end
    context '削除リンクのテスト' do
      it 'application.html.erbにjavascript_include_tagを含んでいる' do
        is_exist = 0
        open("app/views/layouts/application.html.erb").each do |line|
          strip_line = line.chomp.gsub(" ", "")
          if strip_line.include?("<%=javascript_include_tag'application','data-turbolinks-track':'reload'%>")
            is_exist = 1
            break
          end
        end
        expect(is_exist).to eq(1)
      end
      before do
        click_link '削除'
      end
      it '正しく削除される' do
        expect(PhotoImage.where(id: photo_image.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/photo_images'
      end
    end
  end

  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_photo_image_path(photo_image)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/photo_image/' + photo_image.id.to_s + '/edit'
      end
       it '編集前の名前と説明がフォームに表示(セット)されている' do
        expect(page).to have_field 'photo_image[name]', with: photo_image.name
        expect(page).to have_field 'photo_image[caption]', with: photo_image.caption
      end
      it '投稿ボタンが表示される' do
        expect(page).to have_button '投稿'
      end
    end

    context '編集成功のテスト' do
      before do
        @photo_image_old_name = photo_image.name
        @photo_image_old_caption = photo_image.caption
        fill_in 'photo_image[name]', with: Faker::Lorem.characters(number: 4)
        fill_in 'photo_image[caption]', with: Faker::Lorem.characters(number: 19)
        click_button '投稿'
      end

      it '名前が正しく更新される' do
        expect(photo_image.reload.name).not_to eq @photo_image_old_name
      end
      it '説明が正しく更新される' do
        expect(photo_image.reload.caption).not_to eq @photo_image_old_caption
      end
      it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
        expect(current_path).to eq '/photo_image/' + photo_image.id.to_s
      end
    end
  end

  describe 'ユーザ一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users'
      end
      it '自分と他人の画像が表示される: fallbackの画像がサイドバーの1つ＋一覧(2人)の2つの計3つ存在する' do
        expect(all('img').size).to eq(3)
      end
      it '自分と他人の名前がそれぞれ表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
      end
      it '自分と他人のshowリンクがそれぞれ表示される' do
        expect(page).to have_link 'Show', href: user_path(user)
        expect(page).to have_link 'Show', href: user_path(other_user)
      end
    end
  end

  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '投稿一覧のユーザ画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(user)
      end
      it '投稿一覧に自分の投稿した写真の名前が表示され、リンクが正しい' do
        expect(page).to have_link photo_image.name, href: photo_image_path(photo_image)
      end
      it '投稿一覧に自分の投稿の説明が表示される' do
        expect(page).to have_content photo_image.caption
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_photo_image.name
        expect(page).not_to have_content other_photo_image.caption
      end
      it 'プロフィール編集リンクが表示される' do
	       edit_link = find_all('a')[0]
	       expect(edit_link.native.inner_text).to match(/edit/i)
			 end
    end
     context 'リンクの遷移先の確認' do
	     it 'Editの遷移先は編集画面か' do
	       edit_link = find_all('a')[0]
	       edit_link.click
	       expect(current_path).to eq('/users/' + photo_image.id.to_s + '/edit')
	     end
	   end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '変更ボタンが表示される' do
        expect(page).to have_button '変更を保存'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        click_button '変更を保存'
      end

      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
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
end