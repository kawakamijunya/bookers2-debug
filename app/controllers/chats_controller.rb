class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id]) #①チャット相手の特定
    rooms = current_user.user_rooms.pluck(:room_id) #②自分(current_user)に紐付くRoomを全て取得
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms) #③チャット相手と共通のRoomを持つ中間テーブルがあるか確認

    if user_rooms.nil? #⑥共通のチャットルームがない場合
      #⑥-1 新しくチャットルームを作る
      @room = Room.new
      @room.save
      #⑥-2 そのルームidを共通してもつ中間テーブルを、相手と自分の2人分作る
      UserRoom.create(user_id: @user.id, room_id: @room.id)
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
    else
      @room = user_rooms.room #④共通のチャットルームがあれば、それに紐付くroomを「@room」に代入する
    end
    #⑤「チャット履歴(@chats)の取得」「新規投稿用の空インスタンス(@chat)作成」
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end


  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
  end

  private

  def chat_params
    params.require(:chat).permit(:message,:room_id)
  end

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end


end
