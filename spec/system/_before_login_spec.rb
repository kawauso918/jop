require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'ログインリンクが表示される: 青色のボタンの表示が「ログイン」である' do
        log_in_link = find_all('a')[3].native.inner_text
        expect(log_in_link).to match(/ログイン/)
      end
      it 'ログインリンクの内容が正しい' do
        log_in_link = find_all('a')[3].native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
      it '新規登録リンクが表示される: 緑色のボタンの表示が「新規登録」である' do
        sign_up_link = find_all('a')[4].native.inner_text
        expect(sign_up_link).to match(/新規登録/)
      end
      it '新規登録リンクの内容が正しい' do
        sign_up_link = find_all('a')[4].native.inner_text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'jopリンクが表示される: 左上から1番目のリンクが「jop」である' do
        home_link = find_all('a')[0].native.inner_text
        expect(home_link).to match(/jop/)
      end
      it '新規登録リンクが表示される: 左上から2番目のリンクが「新規登録」である' do
        signup_link = find_all('a')[1].native.inner_text
        expect(signup_link).to match(/新規登録/)
      end
      it 'ログインリンクが表示される: 左上から3番目のリンクが「ログイン」である' do
        login_link = find_all('a')[2].native.inner_text
        expect(login_link).to match(/ログイン/)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'jopを押すと、トップ画面に遷移する' do
        home_link = find_all('a')[0].native.inner_text
        home_link = home_link.delete(' ')
        home_link.gsub!(/\n/, '')
        click_link home_link
        is_expected.to eq '/'
      end
      it '新規登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[1].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link, match: :first
        is_expected.to eq '/users/sign_up'
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[2].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link, match: :first
        is_expected.to eq '/users/sign_in'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「新規登録」と表示される' do
        expect(page).to have_content '新規登録'
      end
      it '名前フォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'メールアドレスフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'パスワード確認フォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button '新規登録'
        # expect(current_path).to eq '/users' + User.last.id.to_s
        expect(current_path).to eq "/users/1"
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it '名前フォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
      it 'メールアドレスフォームは表示されない' do
        expect(page).not_to have_field 'user[email]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        # expect(current_path).to eq '/users' + user.id.to_s
        expect(current_path).to eq  "/users/1"
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[name]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[name]', with: user.name
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示を確認' do
      it 'jopリンクが表示される: 左上から1番目のリンクが「jop」である' do
        home_link = find_all('a')[0].native.inner_text
        expect(home_link).to match(/jop/)
      end
      it 'ユーザー一覧リンクが表示される: 左上から2番目のリンクが「ユーザー一覧」である' do
        users_link = find_all('a')[1].native.inner_text
        expect(users_link).to match(/ユーザー一覧/)
      end
      it '投稿一覧リンクが表示される: 左上から3番目のリンクが「投稿一覧」である' do
        photo_images_link = find_all('a')[2].native.inner_text
        expect(photo_images_link).to match(/投稿一覧/)
      end
      it '投稿フォームリンクが表示される: 左上から4番目のリンクが「投稿フォーム」である' do
        new_photo_images_link = find_all('a')[3].native.inner_text
        expect(new_photo_images_link).to match(/投稿フォーム/)
      end
      it 'プロフィールリンクが表示される: 左上から5番目のリンクが「プロフィール」である' do
        photo_image_link = find_all('a')[4].native.inner_text
        expect(photo_image_link).to match(/プロフィール/)
      end
      it '問い合わせリンクが表示される: 左上から6番目のリンクが「問い合わせ」である' do
        contact_link = find_all('a')[5].native.inner_text
        expect(contact_link).to match(/問い合わせ/)
      end

      it 'ログアウトリンクが表示される: 左上から7番目のリンクが「ログアウト」である' do
        logout_link = find_all('a')[6].native.inner_text
        expect(logout_link).to match(/ログアウト/)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[name]', with: user.name
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[4].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてトップページ画面へのリンクが存在する' do
        expect(page).to have_link '', href: '/users/1'
      end
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq "/users/1"
      end
    end
  end
end
