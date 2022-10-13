--Update: Обновил позывные/состав
-- Информация о скрипте
script_name('«Auto-Doklad»') 		                    -- Указываем имя скрипта
script_version(3.95) 						            -- Указываем версию скрипта / FINAL
script_author('Henrich_Rogge', 'Marshall_Milford', 'Andy_Fawkess') 	-- Указываем имя автора

-- Библиотеки
require 'lib.moonloader'
require 'lib.sampfuncs'
local dlstatus = require('moonloader').download_status


-- Позывные
local nicks = { -- [''] = '',
-- 12+
  ['Cross_Dacota'] = 'Драко', -- Подполковник.
  ['Vlad_Werber'] = 'Окунь', -- Майор.
-- Ком. состав.
  ['Blayzex_Stoun'] = 'Медведь', -- Командир.
  ['Sergey_Fibo'] = 'Панда', -- Куратор.
  
-- Бойцы.
  ['Nolik_Quiles'] = 'Ноль',
  ['Anthony_Diez'] = 'Ворон',
  
-- Стажеры.
  ['Fara_Rest'] = 'Фара',
  ['Ace_Derden'] = 'Эйс',
  ['Sentinell_Cunningham'] = 'Гуль',
  ['Jo_Bax'] = 'Бакс',
  ['Nakimura_Scandalist'] = 'Мефедрон',
  ['Benedict_Bradberry'] = 'Беня',
  ['Nikolay_Christenson'] = 'Гугл',
  ['Oscar_Sanchez'] = 'Тайфун',
  ['Linkoln_Esuo'] = 'Ёсик',
  ['Romario_Nax'] = 'Нах',
  ['Jo_Bax'] = 'Бакс',
  ['Ruslan_Below'] = 'Кот',
  ['Ernesto_Vaillant'] = 'Рулет',
  ['Shredder_Rose'] = 'Роза',
  ['Gofi_Interno'] = 'Интерн',
  ['Matthew_Melody'] = 'Ангел',
  ['Pull_Krove'] = 'Кадеин',
  ['Kenny_Vaillant'] = 'Качан',
  ['Lucas_Stoun'] = 'Бурбон',
  ['Azim_Kenes'] = 'Довакин',
  ['Kirill_Magomedov'] = 'Мага',
  ['Serand_Calebron'] = 'Калибр',
  ['Marcus_Stoun'] = 'Иней'
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
	downloadUrlToFile('https://raw.githubusercontent.com/DianO4ka228/erp-script/main/online-update.json', filepath, function(id, status, p1, p2)
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