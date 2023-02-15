script_name('AcademyHelper')
script_author('H4rkotuk')

require "lib.moonloader" -- библиотеки
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local imgui = require 'imgui'
local encoding = require 'encoding'
local keys = require "vkeys"
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false
local script_vers = 7
local script_vers_text = "1.20"

local update_url = "https://raw.githubusercontent.com/Harkotuk/scripts/main/AH.ini" -- ссылка на .ini
local update_path = getWorkingDirectory() .. "/AH.ini" -- название .ini

local script_url = "https://github.com/Harkotuk/scripts/blob/main/AcademyHelp.luac?raw=true" -- ссылка на скрипт
local script_path = thisScript().path
local sw, sh = getScreenResolution()

local dsc_window_state = imgui.ImBool(false)
local teo_window_state = imgui.ImBool(false)
local yk_window_state = imgui.ImBool(false)
local ak_window_state = imgui.ImBool(false)
local fp_window_state = imgui.ImBool(false)

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
	sampAddChatMessage ("[Academy]{CCCCCC} Активация - {0000CD}/um", 0x0000CD)
	thread = lua_thread.create_suspended(thread)
    sampRegisterChatCommand("um", cmd_dsc)
    imgui.Process = false

    downloadUrlToFile(update_url, update_path, function(id, status) -- провека на обновление
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("[Academy]{CCCCCC} Доступно обновление! Начинается загрузка!", 0x0000CD)
                update_state = true
            end
            os.remove(update_path)
        end
    end)
    while true do
        wait(0)
		if update_state then -- автообновление
			downloadUrlToFile(script_url, script_path, function(id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					sampAddChatMessage("[Academy]{CCCCCC} Скрипт обновлён!", 0x0000CD)
					thisScript():reload()
				end
			end)
			break
		end
    end
end

function cmd_dsc(arg) -- Открытие "Главное меню"
	dsc_window_state.v = not dsc_window_state.v
	imgui.Process = dsc_window_state.v
end
function teo_dsc(arg) -- Открытие "Теория"
	teo_window_state.v = not teo_window_state.v
	imgui.Process = teo_window_state.v
end
function yk_dsc(arg) -- Открытие "Теория"
	yk_window_state.v = not yk_window_state.v
	imgui.Process = yk_window_state.v
end
function ak_dsc(arg) -- Открытие "Теория"
	ak_window_state.v = not ak_window_state.v
	imgui.Process = ak_window_state.v
end
function fp_dsc(arg) -- Открытие "Теория"
	fp_window_state.v = not fp_window_state.v
	imgui.Process = fp_window_state.v
end

function imgui.OnDrawFrame()
    if not dsc_window_state.v and not teo_window_state.v and not yk_window_state.v then
        imgui.Process = false
    end
    if dsc_window_state.v then -- Главное меню скрипта
        imgui.SetNextWindowSize(imgui.ImVec2(350, 240), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"AcademyHelp", dsc_window_state, imgui.WindowFlags.NoResize)
            if imgui.Button(u8'Вводная лекция кадетам', imgui.ImVec2(322, 22)) then
                thread:run(1)
            end
            if imgui.Button(u8'Вводная лекция к/с', imgui.ImVec2(322, 22)) then
                thread:run(2)
            end
            if imgui.Button(u8'Лекция для CPD', imgui.ImVec2(322, 22)) then
                thread:run(3)
            end
            imgui.Separator()
            if imgui.Button(u8'Теория', imgui.ImVec2(322, 22)) then
                teo_window_state.v = true
            end
            imgui.Separator()
            if imgui.Button(u8'Завершить отыгровку', imgui.ImVec2(322, 22)) then
                thread:run(4)
            end
            if imgui.Button(u8'Перезагрузить скрипт', imgui.ImVec2(322, 22)) then
                thread:run(5)
            end
        imgui.End()
    end
    if teo_window_state.v then -- Теория меню
        imgui.SetNextWindowSize(imgui.ImVec2(350, 150), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"Теория", teo_window_state, imgui.WindowFlags.NoResize)
            if imgui.Button(u8'УК', imgui.ImVec2(322, 22)) then
                yk_window_state.v = true
            end
            if imgui.Button(u8'АК', imgui.ImVec2(322, 22)) then
                ak_window_state.v = true
            end
            if imgui.Button(u8'ФП', imgui.ImVec2(322, 22)) then
                fp_window_state.v = true
            end
        imgui.End()
    end
    if yk_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(150, 150), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"Уголовный Кодекс", yk_window_state, imgui.WindowFlags.NoResize)
            if imgui.Button(u8'1.1 5.2', imgui.ImVec2(122, 22)) then
                sampSendChat("Гражданин, начал избивать проходящего рядом человека, после чего пытался уйти от сотрудников ПО.")
            end
            if imgui.Button(u8'7.2 8.1', imgui.ImVec2(122, 22)) then
                sampSendChat("У бандита при обыске были найдены наркотические вещества и оружие без лицензии.")
            end
            if imgui.Button(u8'11.5 20.1', imgui.ImVec2(122, 22)) then
                sampSendChat("Гражданин пока ехал в участок, оскорблял сотрудника полиции и взломал базу.")
            end
        imgui.End()
    end
    if ak_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(150, 150), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"Административный Кодекс", ak_window_state, imgui.WindowFlags.NoResize)
        if imgui.Button(u8'10.1 13.2', imgui.ImVec2(122, 22)) then
            sampSendChat("Гражданин бросался под колеса машин, и просил денег.")
        end
        if imgui.Button(u8'5.1 7.1', imgui.ImVec2(122, 22)) then
            sampSendChat("Водитель сел за руль пьяный, после чего начал ездить по газону.")
        end
        if imgui.Button(u8'1.1 2.1', imgui.ImVec2(122, 22)) then
            sampSendChat("Водитель находясь в трезвом состоянии двигаясь по встречной полосе сбил человека.")
        end
        imgui.End()
    end
    if fp_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(150, 150), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"Федеральное Постановление", fp_window_state, imgui.WindowFlags.NoResize)
        if imgui.Button(u8'3.3 3.7', imgui.ImVec2(122, 22)) then
            sampSendChat("Офицер полиции, сговорившись с мафией, ночью продавал им ключи. ")
        end
        if imgui.Button(u8'1.2 1.3', imgui.ImVec2(122, 22)) then
            sampSendChat("Офицер LVPD, начал унижать гражданина на посту, а затем применил к нему насилие. ")
        end
        if imgui.Button(u8'2.1 4.3', imgui.ImVec2(122, 22)) then
            sampSendChat("Офицер SFPD, зашел в офис FBI без разрешения, затем начал оскорблять Агентов Бюро.")
        end
        imgui.End()
    end
end

function thread(arg) -- Потоки(для отыгровок)
    if arg == 1 then
        sampSendChat("Слушаем внимательно и не перебиваем. Все вопросы после лекции.")
        wait(7000)
        sampSendChat("Поздравляю, офицер.")
        wait(7000)
        sampSendChat("Вы зачислены в ряды полицейской академии Лос-Сантос.")
        wait(7000)
        sampSendChat("Твой значок №19")
        wait(7000)
        sampSendChat("/b Ваш тэг в рацию - /r Student of Academy: Текст")
        wait(7000)
        sampSendChat("Срок Вашего обучения составляет два полных дня.")
        wait(7000)
        sampSendChat("Вы можете сдать все в один день.")
        wait(7000)
        sampSendChat("Первый экзамен: вводная лекция и сдача теории.")
        wait(7000)
        sampSendChat("Второй экзамен: практика 10-55 и Арест.")
        wait(7000)
        sampSendChat("По итогам прохождения обучения, вы будете зачислены в отдел CPD")
        wait(7000)
        sampSendChat("Department of Petrol and Roof Traffic — основной базовый отдел полицейского управления.")
        wait(7000)
        sampSendChat("Если Вам необходима практика проведения 10-55 или ареста - попросите лектора и выше ее провести.")
        wait(7000)
        sampSendChat("CRASH - подразделение департамента, предназначенный для снижения уровня преступности криминальных банд в городе.")
        wait(7000)
        sampSendChat("Academy - отдел, отвечающий за обучение новых кадров для дальнейшей службы в департаменте.")
        wait(7000)
        sampSendChat('На сегодняшний день, в департаменте существуют три отдела и один спецотряд: Academy, DPRT, CRASH, RRS «GHOST».')
        wait(7000)
        sampSendChat("/b https://vk.cc/ciATfg - ссылка на беседу, там ты найдешь нужную информацию.")
        wait(7000)
        sampSendChat("На этом данная лекция подходит к концу, у Вас есть какие-то вопросы?")
    end
    if arg == 2 then
        sampSendChat("Слушаем внимательно и не перебиваем. Все вопросы после лекции.")
        wait(7000)
        sampSendChat("Поздравляю, офицер.")
        wait(7000)
        sampSendChat("Вы зачислены в ряды полицейской академии Лос-Сантос.")
        wait(7000)
        sampSendChat("Твой значок №19")
        wait(7000)
        sampSendChat("/b Ваш тэг в рацию - /r Student of Academy: Текст")
        wait(7000)
        sampSendChat("Срок Вашего обучения составляет два полных дня.")
        wait(7000)
        sampSendChat("Вы можете сдать все в один день.")
        wait(7000)
        sampSendChat("Первый экзамен: вводная лекция и сдача теории.")
        wait(7000)
        sampSendChat("Второй экзамен: практика 10-55 и Арест.")
        wait(7000)
        sampSendChat("Вы можете сдать все в первый день и получить звание указанное в контракте.")
        wait(7000)
        sampSendChat("По итогам прохождения обучения, вы будете зачислены в отдел CPD")
        wait(7000)
        sampSendChat("Department of Petrol and Roof Traffic — основной базовый отдел полицейского управления.")
        wait(7000)
        sampSendChat("Если Вам необходима практика проведения 10-55 или ареста - попросите лектора и выше ее провести.")
        wait(7000)
        sampSendChat("CRASH - подразделение департамента, предназначенный для снижения уровня преступности криминальных банд в городе.")
        wait(7000)
        sampSendChat("Academy - отдел, отвечающий за обучение новых кадров для дальнейшей службы в департаменте.")
        wait(7000)
        sampSendChat('На сегодняшний день, в департаменте существуют два отдела и один спецотряд: Academy, DPRT, CRASH, RRS "GHOST".')
        wait(7000)
        sampSendChat("/b https://vk.cc/ciATfg - ссылка на беседу, там ты найдешь нужную информацию.")
        wait(7000)
        sampSendChat("На этом данная лекция подходит к концу, у Вас есть какие-то вопросы?")
    end
    if arg == 3 then
        sampSendChat("Приветствую, Офицер. Поздравляю с повышением.")
        wait(7000)
        sampSendChat("Сейчас я прочитаю лекцию про дальнейшую вашу работу, все вопросы после лекции.")
        wait(7000)
        sampSendChat("Ты переводишься в отдел DPRT - Department of Petrol and Roof Traffic. Твой значок №31.")
        wait(7000)
        sampSendChat("/b Тэг в рацию Officer of DPRT | /r Officer of DPRT: Проверка связи.")
        wait(7000)
        sampSendChat("Отдел CPD выполняет функции охраны общественного порядка и обеспечения общественной безопасности на улицах...")
        wait(7000)
        sampSendChat("...объектах транспорта и иных общественных местах, также контроля безопасности общественных мест...")
        wait(7000)
        sampSendChat("...регулирования дорожного движения и предотвращения уголовных и административных нарушений.")
        wait(7000)
        sampSendChat("Вся более подробная информация находится на официальном портале департамента.")
        wait(7000)
        sampSendChat("/b evolve-rp.su > Игровой сервер Saint Louis > LSPD > Отделы департамента > CPD")
        wait(7000)
        sampSendChat("Желаю успехов и профессионального карьерного роста в нашем департаменте.")
        wait(7000)
        sampSendChat("На этом лекция окончена. Если имеются вопросы , задавайте.")
    end
    if arg == 4 then -- завершить отыгровку
        sampAddChatMessage("[Academy]{CCCCCC} Отыгровка завершена!", 0x0000CD)
        wait(10)
        return false
    end
    if arg == 5 then -- перезагрузка
		imgui.ShowCursor = false
		wait(100)	
        sampAddChatMessage("[Academy]{CCCCCC} Перезагрузка скрипта!", 0x0000CD)		
        wait(100)		
		thisScript():reload()
    end
end
function onWindowMessage(msg, wparam, lparam) -- закрытые на ESC
	if msg == 0x100 or msg == 0x101 then
		if (wparam == keys.VK_ESCAPE and (dsc_window_state.v or teo_window_state.v or yk_window_state.v or ak_window_state.v or fp_window_state.v)) and not isPauseMenuActive() and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then
			consumeWindowMessage(true, false)
			if msg == 0x101 then
                if ak_window_state.v then
					ak_window_state.v = false; dsc_window_state.v = true; teo_window_state.v = true
				end
                if yk_window_state.v then
					yk_window_state.v = false; dsc_window_state.v = true; teo_window_state.v = true
				end
                if fp_window_state.v then
					fp_window_state.v = false; dsc_window_state.v = true; teo_window_state.v = true
				end
			end
		end
	end
end
function style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowPadding = imgui.ImVec2(15, 15)
	style.WindowRounding = 1.5
	style.FramePadding = imgui.ImVec2(5, 5)
	style.FrameRounding = 4.0
	style.ItemSpacing = imgui.ImVec2(12, 8)
	style.ItemInnerSpacing = imgui.ImVec2(8, 6)
	style.IndentSpacing = 25.0
	style.ScrollbarSize = 15.0
	style.ScrollbarRounding = 9.0
	style.GrabMinSize = 5.0
	style.GrabRounding = 3.0
	
	if theme == 1 or theme == nil then
		colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
		colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
		colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
		colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
		colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
		colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
		colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
		colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
		colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
		colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
	end
end
style()