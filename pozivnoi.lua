--Update: Обновил позывные/состав
-- Информация о скрипте
script_name('«Auto-Doklad»') 		                    -- Указываем имя скрипта
script_version(3.15) 						            -- Указываем версию скрипта / FINAL
script_author('Henrich_Rogge', 'Marshall_Milford', 'Andy_Fawkess') 	-- Указываем имя автора

-- Библиотеки
require 'lib.moonloader'
require 'lib.sampfuncs'
local dlstatus = require('moonloader').download_status


-- Позывные
local nicks = { -- [''] = '',
-- 12+
  ['Yupi_Mean'] = 'Юпик', -- Генерал.
  ['Grace_Osborn'] = 'Вдова', -- Полковник.
  ['Emma_Cooper'] = 'Мать', -- Полковник.
  ['Wurn_Linkol'] = 'Даркхолм', -- Подполковник.
  ['Cross_Dacota'] = 'Драко', -- Подполковник.
  ['Kirill_Magomedov'] = 'Мага', -- Майор.

-- Ком. состав.
  ['Satoshi_Sapporo'] = 'Сато', --Куратор.
   -- Командир.
  ['Nika_Black'] = 'Багира', -- Зам. Командира.
  ['Sergey_Fibo'] = 'Панда', -- Зам. Командира.
  ['Sky_Sillence'] = 'Таеро', -- Инструктор.
  ['Kwenyt_Hokage'] = 'Скорпион', -- Инструктор.
  
-- Бойцы.
  ['Foxit_Makayonok'] = 'Лис',
  ['Alex_Frank'] = 'Немец',
  ['Sofa_Meow'] = 'Киса',
  ['Max_Meow'] = 'Кот',
  ['Ashley_Spaze'] = 'Серый',
  ['Lautaro_Spaze'] = 'Капрал', 
  ['Jeremy_Spaze'] = 'Фрост',
  ['Hawii_Tearz'] = 'Шаха',
  ['Siegmund_Berg'] = 'Зодд',
  ['Aiden_Florestino'] = 'Призрак',
  ['Anthony_Diez'] = 'Медведь',
  ['Walter_Moonlight'] = 'Мун',
  ['Kenjiro_Matsukawa'] = 'Клён',
  ['Ashton_Beasley'] = 'Ашот',
  ['Shannon_Spaze'] = 'Рамос',
  ['Chloe_Spaze'] = 'Солнце',
  ['Ayanxkoji_Omalley'] = 'Моль',
  ['Dini_Raksize'] = 'Дино',
  ['Comtonia_Oceguera'] = 'Компот',
  ['Makar_Ryabov'] = 'Чех',
  ['Blayzex_Stoun'] = 'Джамбо',
  ['Sibewest_Silence'] = 'Сало',
  
-- Стажеры.
  ['Azim_Kenes'] = 'Фантом',
  ['Kirill_Shatunov'] = 'Север',
  ['Chris_Ludvig'] = 'Янки',
  ['Calvin_Espinozzi'] = 'Ноззи',
  ['Suleyman_Zelimxanov'] = 'Скандал',
  ['Henry_Markano'] = 'Ханк',
  ['Jason_Storm'] = 'Шторм',
  ['Christian_Monet'] = 'Монета'
}

function main()
  
  -- Проверяем загружен ли sampfuncs и SAMP если не загружены - возвращаемся к началу
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
  -- Проверяем загружен ли SA-MP
	while not isSampAvailable() do wait(100) end
  -- Сообщаем об загрузке скрипта
  stext('Скрипт успешно загружен!')
  
  -- Регистрируем команду
  sampRegisterChatCommand('dok', cmd_dok)
  -- Проверяем зашёл ли игрок на сервер
	while not sampIsLocalPlayerSpawned() do wait(0) end
	-- Проверка на автозагрузку.
  updateScript()
  -- Бесконечный цикл для постоянной работы скрипта
  while true do
    wait(0)
  end
end



function cmd_dok(args)
  local info = {}
  if isCharInAnyCar(PLAYER_PED) then
    if #args ~= 0 then
      local mycar = storeCarCharIsInNoSave(PLAYER_PED)
      for i = 0, 999 do
        if sampIsPlayerConnected(i) then
          local ichar = select(2, sampGetCharHandleBySampPlayerId(i))
          if doesCharExist(ichar) then
            if isCharInAnyCar(ichar) then
              local icar = storeCarCharIsInNoSave(ichar)
              if mycar == icar then
                local nicktoid = sampGetPlayerNickname(i)
                if nicks[nicktoid] ~= nil then
                  local call = nicks[nicktoid]
                  table.insert(info, call)
                else
                  local nick = string.gsub(sampGetPlayerNickname(i), "(%u+)%l+_(%w+)", "%1.%2")
                  table.insert(info, nick)
                end
              end
            end
          end
        end
      end
      if #info > 0 then
        sampProcessChatInput(string.format('/r 10-%s, %s.', args, table.concat(info,', ')))
      else
        sampProcessChatInput(string.format('/r 10-%s, solo.', args))
      end
    else
      atext('{808080}Информация | {FFFFFF}Введите: /dok тен-код.')
      return
    end
  else
    atext('{808080}Ошибка | {FFFFFF}Вы не сидите в транспорте.')
    return
  end
end

-- «Auto-Report» text
function stext(text)
  sampAddChatMessage((' %s {FFFFFF}%s'):format(script.this.name, text), 0xABAFDE)
end

-- » text
function atext(text)
	sampAddChatMessage((' » {FFFFFF}%s'):format(text), 0xABAFDE)
end

-- Авто-обновление
function updateScript()
	local filepath = os.getenv('TEMP') .. '\\online-update.json'
	downloadUrlToFile('https://raw.githubusercontent.com/Enotiwe/erp-script/main/online-update.json', filepath, function(id, status, p1, p2)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			local file = io.open(filepath, 'r')
			if file then
				local info = decodeJson(file:read('*a'))
				updatelink = info.updateurl
				if info and info.latest then
					if tonumber(thisScript().version) < tonumber(info.latest) then
						lua_thread.create(function()
							print('Началось скачивание обновления. Скрипт перезагрузится через пару секунд.')
							wait(300)
							downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
								if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then print('Обновление успешно скачано и установлено.')
								elseif status1 == 64 then print('Обновление успешно скачано и установлено.')
								end
							end)
						end)
					else print('Обновлений скрипта не обнаружено.') end
				end
			else print('Проверка обновления прошла неуспешно. Запускаю старую версию.') end
		elseif status == 64 then print('Проверка обновления прошла неуспешно. Запускаю старую версию.') end
	end)
end