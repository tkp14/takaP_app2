include ApplicationHelper # full_titleメソッドの読み込み

# テストユーザーがログイン中の場合にtrueを返す
def is_logged_in?
  !session[:user_id].nil?
end
