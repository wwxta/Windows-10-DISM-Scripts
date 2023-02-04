# Windows-10-DISM-Scripts / [Windows-11-DISM-Scripts](https://github.com/Mitradis/Windows-11-DISM-Scripts)
Support languages\支持语言\Поддерживаемые языки: EN-US\ZH-CN\RU-RU

Image optimization by removing pre-installed junk packages, disabling update tasks, disabling Defender and other minor changes. All this is done by standard means (DISM commands, CMD queries and changing registry keys). The goal is to get in a natural way (without interfering with system files) the most standard, clean image with unnecessary elements disabled. Disabled in the most efficient, safest and easiest way, without making a bunch of thoughtless and unnecessary edits.

通過刪除預安裝的垃圾包、禁用更新任務、禁用 Defender 和其他細微更改來優化圖像。 所有這些都是通過標準方式（DISM 命令、CMD 查詢和更改註冊表項）完成的。 目標是以自然的方式（不干擾系統文件）獲得最標準、最乾淨的圖像，並禁用不必要的元素。 以最有效、最安全和最簡單的方式禁用，無需進行大量輕率和不必要的編輯。

Оптимизация образа путем удаления предустановленных пакетов программ-мусора, отключение задач обновления, отключение Защитника и другие мелкие изменения. Все это производится стандартными средствами (командами DISM, запросами CMD и изменением ключей реестра). Цель - получить естественным путем (без вмешательства в системные файлы) максимально стандартный, чистый образ с отключенными ненужными элементами. Отключенными самыми эффективными, безопасными и простыми способами, без внесения кучи бездумных и ненужных правок.

Все подробности тут: [vk.com/@slmp_mod-windows-10-dism-scripts](https://vk.com/@slmp_mod-windows-10-dism-scripts)

# Using:
- The image must be mounted.
- You need any disk (if RAM, then you need support for NTFS DISM commands, SoftPerfect RAM Disk and analogues), with the letter Z, larger than 11500MB.
- Unpack the scripts, install.wim and boot.wim files (from the source folder of the .iso file) to the root of the disk.
- If the system language differs from Russian, replace “ru-RU” in _Clear.bat, in the OneDrive block, with your version.
- Run _Clear.bat and wait for the window to close.
- Make sure there are no errors in the Clear.log file by searching: “operation”, “errors”, “not”, “no”.
- Launch CMD and execute the first command from the _Readme.txt file.
- Using UltraISO (or analogues), delete the install.wim file in the .iso image and add the resulting install.esd and boot.wim.
- The image is ready.

# 应用：
- 必須安裝映像。
- 您需要任何磁盤（如果是 RAM，則需要支持 NTFS DISM 命令、SoftPerfect RAM 磁盤和類似物），字母 Z 大於 11500MB。
- 將腳本、install.wim 和 boot.wim 文件（從 .iso 文件的源文件夾）解壓到磁盤的根目錄。
- 如果系統語言不同於俄語，請將 OneDrive 塊中 _Clear.bat 中的“ru-RU”替換為您的版本。
- 運行 _Clear.bat 並等待窗口關閉。
- 通過搜索“operation”、“errors”、“not”、“no”確保 Clear.log 文件中沒有錯誤。
- 啟動 CMD 並執行 _Readme.txt 文件中的第一條命令。
- 使用 UltraISO（或類似物），刪除 .iso 映像中的 install.wim 文件並添加生成的 install.esd 和 boot.wim。
- 圖像已準備就緒。

# Применение:
- Образ должен быть смонтирован.
- Понадобиться любой диск (если RAM, то нужна поддержка NTFS DISM команд, SoftPerfect RAM Disk и аналоги), с буквой Z, размером более 11500МБ.
- Распаковать скрипты, файлы install.wim и boot.wim (из папки source файла .iso) в корень диска.
- В случае отличия языка системы от русского, заменить в _Clear.bat «ru-RU», в блоке OneDrive, на свою версию.
- Запустить _Clear.bat и ожидать завершение работы окна.
- Убедится в отсутствии ошибок в файле Clear.log по поиску: «операция», «оши», «не », «нет».
- Запустить CMD и выполнить первую команду из файла _Readme.txt.
- С помощью UltraISO (или аналогов) удалить в .iso образе файл install.wim и добавить получившийся install.esd и boot.wim.
- Образ готов.
