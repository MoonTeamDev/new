-- This script is based on telegram-cli sample lua script by @vysheng, 
-- written to demonstrate how to use tdlib.lua for your telegram-cli bot.

-- Load tdcli library.
--tdcli = dofile('tdcli.lua')
--local redis = require 'redis'
--redis = (loadfile "redis.lua")()
--JSON = require('dkjson')
--db = require('redis')
--redis = db.connect('127.0.0.1', 6379)
--serpent = require('serpent')
--redis:select(2)}
tdcli = dofile('tdcli.lua')
--redis = dofile('redis.lua')
JSON = require('dkjson')
serpent = require('serpent')
--redis = (loadfile "./libs/redis.lua")()
redis = require('redis')
mame = Redis.connect('127.0.0.1', 6379)

function is_sudo(msg)
 local var = false
--  — Check users id in config
  for v,user in pairs(sudo_users) do
  if user == msg.sender_user_id_ then
     var = true
 end
  end
  return var
end
sudo_users = {
  90285047,
  0
}

-- Print message format. Use serpent for prettier result.
function vardump(value, depth, key)
  local linePrefix = ''
  local spaces = ''

  if key ~= nil then
    linePrefix = key .. ' = '
  end

  if depth == nil then
    depth = 0
  else
    depth = depth + 1
    for i=1, depth do 
      spaces = spaces .. '  '
    end
  end

  if type(value) == 'table' then
    mTable = getmetatable(value)
    if mTable == nil then
      print(spaces .. linePrefix .. '(table) ')
    else
      print(spaces .. '(metatable) ')
        value = mTable
    end
    for tableKey, tableValue in pairs(value) do
      vardump(tableValue, depth, tableKey)
    end
  elseif type(value)  == 'function' or 
    type(value) == 'thread' or 
    type(value) == 'userdata' or 
    value == nil then
      print(spaces .. tostring(value))
  elseif type(value)  == 'string' then
    print(spaces .. linePrefix .. '"' .. tostring(value) .. '",')
  else
    print(spaces .. linePrefix .. tostring(value) .. ',')
  end
end

-- Print callback
function dl_cb(arg, data)
  vardump(arg)
  vardump(data)
end

function tdcli_update_callback(data)
  --vardump(data)
  if (data.ID == "UpdateNewMessage") then
    local msg = data.message_
	local msg = data.message_
    local input = msg.content_.text_
    local chat_id = msg.chat_id_
    local user_id = msg.sender_user_id_
    -- If the message is text message
    if msg.content_.ID == "MessageText" then
      -- And content of the text is..
	if msg.content_.text_ == "/ping" then
        -- Reply with regular text
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'pong', 1)
	   --if msg.content_.text_ == "/id" then
        -- Reply with regular text
		tdcli.sendText(msg.chat_id_, 0, 1, msg.chat_id_, 1, 'html')
		elseif input:match('^/setname') and is_sudo(msg) then
        local text = input:gsub('/setname', '')
        --tdcli.changeAccountTtl(text)
		tdcli.changeChatTitle(msg.chat_id_, text)
		elseif input:match('^/creategroup') and is_sudo(msg) then
        local text = input:gsub('/creategroup', '')
		tdcli.createNewGroupChat({[0] = msg.sender_user_id_}, text)
		tdcli.sendText(msg.chat_id_, 0, 1, '_Group Was Created Successfuly_', 1, 'md')
				
		elseif input:match('^/me$') and not is_sudo(msg) then
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_You,re_ *Member*', 1, 'md')
		elseif input:match('^/me$') and is_sudo(msg) then
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_You,re_ *Sudo*', 1, 'md')
	--elseif input:match('^/me$') and is_mod(msg) then
		--tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_You,re Group_ *Admin*', 1, 'md')
			
	elseif input:match('^/closechat') and is_sudo(msg) then
		local text = input:gsub('/closechat', '')
		tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, '_Are You Sure?_\nIf Yes type *yes*\nElse Type *no*', 1, 'md')
		elseif input:match('^yes') and is_sudo(msg) then
		tdcli.closeChat(data.message_.chat_id_)
		elseif input:match('^no') and is_sudo(msg) then
			tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, '*CloseChat* _Progress Has Been Canceled!_', 1, 'md')
		elseif input:match('^/id$') then
			local gpid = '_Chat ID:_ *'..msg.chat_id_..'*\n_Your ID:_ *'..msg.sender_user_id_..'*'
			tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, gpid, 1, 'md')
		elseif input:match('^/tosuper') and is_sudo(msg) then
			local gpid = msg.chat_id_
			tdcli.migrateGroupChatToChannelChat(gpid)
		elseif input:match('^/link') then
			--tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, '_If I,m Creator I,ve Send Gplink On Next Msg_', 1, 'md')
			tdcli.exportChatInviteLink(msg.chat_id_)
			tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, msg.invite_link_, 1, 'md')
			tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, 'Link :'..ChatInviteLink, 1, 'md')
			elseif input:match('^/promote$') and is_sudo(msg) then
		local id = input:gsub('/promote', '')
		text = '_User Has Been Promoted As An Admin!_'
		mame:set('mods'..msg.chat_id_,id)
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
	elseif input:match('^/promote$') and not is_sudo(msg) then
		text = '*You,re Not Sudo*'
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
				elseif input:match('^/demote$') and is_sudo(msg) then
		local id = input:gsub('/demote', '')
		text = '_User Has Been Demoted As An Admin!_'
		mame:del('mods'..msg.chat_id_,id)
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
	elseif input:match('^/demote$') and not is_sudo(msg) then
		text = '*You,re Not Sudo*'
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
		mame:set('mods'..msg.chat_id_,id)
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
	elseif input:match('^/promote$') and not is_sudo(msg) then
		text = '*You,re Not Sudo*'
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
				elseif input:match('^/demote$') and is_sudo(msg) then
		local id = input:gsub('/demote', '')
		text = '_User Has Been Demoted As An Admin!_'
		mame:del('mods'..msg.chat_id_,id)
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
	elseif input:match('^/demote$') and not is_sudo(msg) then
		text = '*You,re Not Sudo*'
		tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
                        elseif input:match('^/typing on$') and is_sudo(msg) then
			hash = 'typing:'..msg.chat_id_
			mame:set(hash,true)
			tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, '_Typing Mode For This Group Has Been Activted_', 1, 'md')
		elseif input:match('^/typing off$') and is_sudo(msg) then
			hash = 'typing:'..msg.chat_id_
			mame:del(hash)
		tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, '_Typing Mode For This Group Has Been DeActivted_', 1, 'md')
		elseif input:match('^/typingall on$') and is_sudo(msg) then
			hash = 'typingall'
			mame:set(hash,'true')
		tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, '_Typing Mode For All Groups Has Been Activted_', 1, 'md')
		elseif input:match('^/typingall off$') and is_sudo(msg) then
			hash = 'typingall'
			mame:del(hash)
		tdcli.sendText(msg.chat_id_, 17, 0, 1, nil, '_Typing Mode For All Groups Has Been DeActivted_', 1, 'md')
		elseif input:match('(.*)') and mame:get('typingall') == 'true' then
			tdcli.sendChatAction(msg.chat_id_, 'Typing')
			elseif input:match('slm') and editMessageText then		
text = '*You,re Not Sudo*'
tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
				
			
			elseif input:match('^/help$') then
			text = [[*Bot* `Commands:`
➖➖➖➖➖
*/help*
➲_Bot Send Bot Commands_

*/ping*
➲_If Bot Online, Send_ `PonG!`

*/id*
➲_Bot Send You And Group Id_

*/me*
➲_Bot Send Your Rank_

➲_Bot Going To Typing Status_

*/typing* `OFF`
➲_Bot Going Out From Typing Status_

*/lock* `FWD|USERNAME|TAG|CMD`
➲_Bot Deleted This Actions If They are Active_

*/unlock* `FWD|USERNAME|TAG|CMD`
➲_Bot Not Deleted This Actions If They are DeActive_

*/ban* `ID|USERNAME|REPLY`
➲_Bot Banned User From Group_

*/unban* `ID|USERNAME|REPLY`
➲_Bot Unbanned User If Banned_

*/banlist*
➲_Bot Send Ban Users List_

*/settings*
➲_Bot Send Group Settings_
➖➖➖➖➖
*Good Luck* `;D`]]
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
				
				elseif input:match('^mute sticker') and is_sudo(msg) then
				text = '*Sticker Posting Has Been Disallowed*'
				mame:set('msticker'..msg.chat_id_, true)
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
				elseif input:match('^mute sticker') and not is_sudo(msg) then
				text = '*You,re Not Mod Or Higher*'
				mame:set('msticker'..msg.chat_id_, true)
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
				elseif input:match('$unmute sticker') and is_sudo(msg) then
				text = '*Sticker Posting Has Been Allowed*'
				mame:del('msticker'..msg.chat_id_)
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
				elseif input:match('$unmute sticker') and not is_sudo(msg) then
				text = '*You,re Not Mod Or Higher*'
				tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
				
		elseif input:match('/lock fwd$') and not mame:get('lfwd:'..msg.chat_id_) and is_sudo(msg) then
			mame:set('lfwd:'..msg.chat_id_, true)
			tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Fwd Has Been Activated_', 1, 'md')
		elseif input:match('/unlock fwd$') and mame:get('lfwd:'..msg.chat_id_) and is_sudo(msg) then
			mame:del('lfwd:'..msg.chat_id_)
			tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Fwd Has Been DeActivated_', 1, 'md')
		elseif mame:get('lfwd:'..chat_id) and msg.forward_info_ and not is_sudo(msg) then
			tdcli.deleteMessages(chat_id, {[0] = msg.id_})
		elseif input:match('^/lock username$') and is_sudo(msg) then
                         mame:set('luser:'..msg.chat_id_, true)
                         tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Username Has Been Activated_', 1, 'md')
                elseif input:match('^/unlock username$') and is_sudo(msg) then
                         mame:del('luser:'..msg.chat_id_)
                         tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Username Has Been DeActivated_', 1, 'md')
                elseif input:match('@') and mame:get('luser:'..msg.chat_id_) and not is_sudo(msg) then
                       tdcli.deleteMessages(chat_id, {[0] = msg.id_})
			elseif input:match('^/lock tag$') and is_sudo(msg) then
                         mame:set('ltag:'..msg.chat_id_, true)
                         tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Tag Has Been Activated_', 1, 'md')
                elseif input:match('^/unlock tag$') and is_sudo(msg) then
                         mame:del('ltag:'..msg.chat_id_)
                         tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Tag Has Been DeActivated_', 1, 'md')
                elseif input:match('#') and mame:get('ltag:'..msg.chat_id_) and not is_sudo(msg) then
                       tdcli.deleteMessages(chat_id, {[0] = msg.id_})
			elseif input:match('^/lock cmd$') and is_sudo(msg) then
                         mame:set('lcmd:'..msg.chat_id_, true)
                         tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Cmd Has Been Activated_', 1, 'md')
                elseif input:match('^/unlock cmd$') and is_sudo(msg) then
                         mame:del('lcmd:'..msg.chat_id_)
                         tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, '_Lock Cmd Has Been DeActivated_', 1, 'md')
                elseif input:match('/') and mame:get('lcmd:'..msg.chat_id_) and not is_sudo(msg) then
                       tdcli.deleteMessages(chat_id, {[0] = msg.id_})
			
    end
		if input:match('^/block') then
			local id = input:gsub('block', '')
			tdcli.blockUser(id)
		elseif input:match('^/unblock') then
			local id = input:gsub('/unblock', '')
			tdcli.unblockUser(id)
		elseif input:match('^/sessions$') then
			tdcli.getActiveSessions()
		end
	
-----settings-----		
local lfwd = 'lfwd:'..chat_id
     if mame:get(lfwd) then
   lfwd = "Active"
   else 
   lfwd = "DeActive"
  end
			
local luser = 'luser:'..chat_id
     if mame:get(luser) then
   luser = "Active"
   else 
   luser = "DeActive"
  end
			
local ltag = 'ltag:'..chat_id
     if mame:get(ltag) then
   ltag = "Active"
   else 
   ltag = "DeActive"
  end
	
local lcmd = 'lcmd:'..chat_id
     if mame:get(lcmd) then
   lcmd = "Active"
   else 
   lcmd = "DeActive"
  end

		if input:match('^/settings$') and is_sudo(msg) then		
text = '_Settings:_\n➖➖➖➖➖\n*Forward:* _'..lfwd..'_\n*Username(@):* _'..luser..'_\n*Tag(#):* _'..ltag..'_\n*Cmd:* _'..lcmd..'_'			
tdcli.sendText(msg.chat_id_, 0, 0, 1, nil, text, 1, 'md')
	
	-------------------------------------------------Junk Codes :/--------------------------------------------------------------------------
		--tdcli.createNewChannelChat(text, 1, 'A Gp Created With MicroSys Bot\n#Developer : @ShopBuy')
		--elseif input:match('^/addme') then
        --local text = input:gsub('addme', '')
		--tdcli.addChatMember(text, msg.sender_user_id_, 20)
      -- And if content of the text is...
      --elseif msg.content_.text_ == "PING" then
        -- Reply with formatted text
      --  tdcli.sendMessage(msg.chat_id_, 0, 1, '<b>PONG</b>', 1, 'html')
				end
      end
  elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
    tdcli_function ({
      ID="GetChats",
      offset_order_="9223372036854775807",
      offset_chat_id_=0,
      limit_=20
    }, dl_cb, nil)
  end
end
