#Requires AutoHotkey v2.0
#SingleInstance Force

global reminderGui := 0
global reminderVisible := false
global reminderState := "hidden"
global reminderAlpha := 0
global fadeDurationSeconds := 2
global nextIntervalSeconds := 1500
global displayDurationSeconds := 20
global fadeTickMilliseconds := 40
global reminderTitle := "该休息啦！"
global reminderMessage := "请离开屏幕，活动一下眼睛和身体。"
global buttonText := "知道了"
global gradientColors := []
global reminderMenu := 0
global nextReminderAt := 0
global trayCountdownLabel := "Next Nap"

; 使用参考脚本中的 Windows 深色主题设置，让通知区域菜单采用深色样式。
SetTrayMenuDarkMode()

; 启动时读取脚本所在目录的配置文件。
LoadConfig()

; 创建带应用图标和动态倒计时的通知区域菜单。
CreateReminderTrayMenu()

; 第一轮提醒在启动后经过配置的间隔时间触发。
ScheduleNextReminder()

/**
 * 从脚本所在目录读取提醒参数、文本和渐变色配置。
 */
LoadConfig() {
    global fadeDurationSeconds, nextIntervalSeconds, displayDurationSeconds, fadeTickMilliseconds
    global reminderTitle, reminderMessage, buttonText, gradientColors

    configPath := A_ScriptDir "\config.ini"
    fadeDurationSeconds := ReadPositiveConfig(configPath, "Reminder", "FadeDurationSeconds", 2)
    nextIntervalSeconds := ReadPositiveConfig(configPath, "Reminder", "NextIntervalSeconds", 1500)
    displayDurationSeconds := ReadPositiveConfig(configPath, "Reminder", "DisplayDurationSeconds", 20)
    reminderTitle := ReadTextConfig(configPath, "Reminder", "ReminderTitle", "该休息啦！")
    reminderMessage := ReadTextConfig(configPath, "Reminder", "ReminderMessage", "请离开屏幕，活动一下眼睛和身体。")
    buttonText := ReadTextConfig(configPath, "Reminder", "ButtonText", "知道了")
    gradientText := ReadTextConfig(configPath, "Reminder", "GradientColors", "0B1220,0D1728,0F1C30,112138,132640,152B48,172F50,193458,1B385F,1D3C66,1F406C,214472")
    gradientColors := ParseGradientColors(gradientText)

    ; 51 个透明度级别对应 0 到 255，按配置换算每次动画的计时间隔。
    fadeTickMilliseconds := Max(10, Round(fadeDurationSeconds * 1000 / 51))
}

/**
 * 为当前进程启用 Windows 深色菜单主题并刷新已缓存的菜单主题。
 * <p>
 * 深色菜单 API 仅在 Windows 10 1809 及更高版本中可用。
 *
 * @author Codex
 * @date 2026/10/14
 * @version 1.0.0
 */
SetTrayMenuDarkMode() {
    if VerCompare(A_OSVersion, "10.0.17763") < 0
        return

    uxtheme := DllCall("kernel32\GetModuleHandle", "Str", "uxtheme", "Ptr")
    if !uxtheme
        return

    setPreferredAppMode := DllCall("kernel32\GetProcAddress", "Ptr", uxtheme, "Ptr", 135, "Ptr")
    flushMenuThemes := DllCall("kernel32\GetProcAddress", "Ptr", uxtheme, "Ptr", 136, "Ptr")
    if !setPreferredAppMode || !flushMenuThemes
        return

    ; 参考 DarkMode.scriptlet 使用 ForceDark 模式刷新进程菜单主题。
    DllCall(setPreferredAppMode, "Int", 2)
    DllCall(flushMenuThemes)
}

/**
 * 创建仅包含标题、动态倒计时和退出项的自定义通知区域菜单。
 * <p>
 *
 * @author Codex
 * @date 2026/10/14
 * @version 1.0.0
 */
CreateReminderTrayMenu() {
    global reminderMenu, trayCountdownLabel

    iconPath := A_ScriptDir "\icon\NapReminder.ico"
    reminderMenu := A_TrayMenu
    reminderMenu.Delete()
    reminderMenu.Add("NapReminder", NoOpMenuItem)
    if FileExist(iconPath)
        reminderMenu.SetIcon("NapReminder", iconPath)
    trayCountdownLabel := "Next Nap"
    reminderMenu.Add(trayCountdownLabel, NoOpMenuItem)
    reminderMenu.Add("Exit", (*) => ExitApp())
    UpdateReminderTrayCountdown()
}

/**
 * 为不带点击事件的通知区域菜单项提供空回调。
 * <p>
 *
 * @param item 菜单项事件参数
 * @author Codex
 * @date 2026/10/14
 * @version 1.0.0
 */
NoOpMenuItem(*) {
}

/**
 * 将下一轮提醒时间设为指定的秒数并启动一次性触发计时器。
 * <p>
 *
 * @author Codex
 * @date 2026/10/14
 * @version 1.0.0
 */
ScheduleNextReminder() {
    global nextIntervalSeconds, nextReminderAt

    nextReminderAt := A_TickCount + (nextIntervalSeconds * 1000)
    SetTimer(ShowBreakReminder, -(nextIntervalSeconds * 1000))
    SetTimer(UpdateReminderTrayCountdown, 1000)
    UpdateReminderTrayCountdown()
}

/**
 * 按剩余秒数刷新通知区域菜单中的下一次休息倒计时。
 * <p>
 * 只显示非零的分钟或秒，倒计时结束时保留 Next Nap 标签。
 *
 * @author Codex
 * @date 2026/10/14
 * @version 1.0.0
 */
UpdateReminderTrayCountdown() {
    global reminderMenu, nextReminderAt, trayCountdownLabel

    if !IsObject(reminderMenu) || nextReminderAt = 0
        return

    remainingSeconds := Max(0, Ceil((nextReminderAt - A_TickCount) / 1000))
    remainingMinutes := remainingSeconds // 60
    remainingSeconds := Mod(remainingSeconds, 60)
    countdownText := "Next Nap"

    if remainingMinutes > 0
        countdownText .= " " remainingMinutes "Min"
    if remainingSeconds > 0
        countdownText .= " " remainingSeconds "Sec"
    if countdownText != trayCountdownLabel {
        reminderMenu.Rename(trayCountdownLabel, countdownText)
        trayCountdownLabel := countdownText
    }
}

/**
 * 使用无 BOM UTF-8 编码读取配置项，避免受系统 ANSI 代码页影响。
 *
 * @param configPath 配置文件路径
 * @param section 配置节名称
 * @param key 配置项名称
 * @param defaultValue 配置项缺失时返回的默认值
 * @return 配置项文本值
 * @author Codex
 * @date 2026/09/02
 * @version 1.0.0
 */
ReadConfigValue(configPath, section, key, defaultValue) {
    if !FileExist(configPath)
        return defaultValue

    ; 显式使用 UTF-8-RAW 读取无 BOM 配置文件。
    file := FileOpen(configPath, "r", "UTF-8-RAW")
    if !file
        return defaultValue

    content := file.Read()
    file.Close()
    currentSection := ""

    for rawLine in StrSplit(content, "`n") {
        line := Trim(rawLine, "`r`t ")
        if line = "" || SubStr(line, 1, 1) = ";"
            continue

        if RegExMatch(line, "^\[(.*)\]$", &sectionMatch) {
            currentSection := Trim(sectionMatch[1])
            continue
        }

        if currentSection = section && RegExMatch(line, "^([^=]+)=(.*)$", &valueMatch) {
            if Trim(valueMatch[1]) = key
                return Trim(valueMatch[2])
        }
    }

    return defaultValue
}

/**
 * 读取一个大于零的秒数配置；文件缺失、格式错误或数值无效时返回默认值。
 *
 * @param configPath 配置文件路径
 * @param section 配置节名称
 * @param key 配置项名称
 * @param defaultValue 无效配置使用的默认秒数
 * @return 有效的正数秒数
 */
ReadPositiveConfig(configPath, section, key, defaultValue) {
    value := ReadConfigValue(configPath, section, key, defaultValue)
    if !RegExMatch(value, "^\s*\d+(\.\d+)?\s*$")
        return defaultValue

    value += 0
    return value > 0 ? value : defaultValue
}

/**
 * 读取文本配置；配置项缺失或为空时返回默认文本。
 *
 * @param configPath 配置文件路径
 * @param section 配置节名称
 * @param key 配置项名称
 * @param defaultValue 无效配置使用的默认文本
 * @return 有效的文本配置
 */
ReadTextConfig(configPath, section, key, defaultValue) {
    value := ReadConfigValue(configPath, section, key, defaultValue)
    return Trim(value) != "" ? value : defaultValue
}

/**
 * 解析逗号分隔的 RGB 十六进制颜色，并在颜色不足时使用内置渐变色。
 *
 * @param configText 逗号分隔的颜色配置文本
 * @return 可用于绘制渐变背景的颜色数组
 */
ParseGradientColors(configText) {
    colors := []
    for _, color in StrSplit(configText, ",") {
        color := Trim(color)
        if RegExMatch(color, "i)^[0-9A-F]{6}$")
            colors.Push(color)
    }

    if colors.Length < 2 {
        return [
            "0B1220", "0D1728", "0F1C30", "112138",
            "132640", "152B48", "172F50", "193458",
            "1B385F", "1D3C66", "1F406C", "214472"
        ]
    }

    return colors
}

/**
 * 显示覆盖主屏幕的休息提醒窗口，并执行配置时长的淡入动画。
 */
ShowBreakReminder() {
    global reminderGui, reminderVisible, reminderState, reminderAlpha, fadeTickMilliseconds
    global reminderTitle, reminderMessage, buttonText, gradientColors

    if reminderVisible
        return

    reminderGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "NapReminder")
    reminderGui.MarginX := 0
    reminderGui.MarginY := 0

    ; 使用配置的多段背景色模拟从上到下的柔和渐变。
    bandHeight := Ceil(A_ScreenHeight / gradientColors.Length)
    for index, color in gradientColors {
        band := reminderGui.AddText(
            "x0 y" ((index - 1) * bandHeight)
            " w" A_ScreenWidth " h" bandHeight
        )
        band.Opt("+Background" color)
    }

    reminderGui.SetFont("s30 cFFFFFF", "Microsoft YaHei UI")
    reminderGui.AddText(
        "x0 y" (A_ScreenHeight // 2 - 90)
        " w" A_ScreenWidth " Center +BackgroundTrans",
        reminderTitle
    )

    reminderGui.SetFont("s16 cD1D5DB", "Microsoft YaHei UI")
    reminderGui.AddText(
        "x0 y" (A_ScreenHeight // 2 - 20)
        " w" A_ScreenWidth " Center +BackgroundTrans",
        reminderMessage
    )

    ; 使用无边框的透明文本控件作为可点击按钮。
    button := reminderGui.AddText(
        "x" (A_ScreenWidth // 2 - 60)
        " y" (A_ScreenHeight // 2 + 50)
        " w120 h40 Center +0x100 +0x200 +BackgroundTrans",
        buttonText
    )
    button.SetFont("s16 cFFFFFF", "Microsoft YaHei UI")
    button.OnEvent("Click", CloseReminder)
    reminderGui.OnEvent("Escape", CloseReminder)
    reminderGui.OnEvent("Close", CloseReminder)

    reminderVisible := true
    reminderState := "showing"
    reminderAlpha := 0

    ; 先隐藏创建窗口并设置透明度，再显示，避免首次弹出时闪烁不透明全屏画面。
    reminderGui.Show("Hide x0 y0 w" A_ScreenWidth " h" A_ScreenHeight)
    ; 隐藏窗口不参与默认标题匹配，开启隐藏窗口检测后再设置透明度。
    DetectHiddenWindows(true)
    WinSetTransparent(0, "ahk_id " reminderGui.Hwnd)
    reminderGui.Show("x0 y0 w" A_ScreenWidth " h" A_ScreenHeight)

    SetTimer(FadeInReminder, fadeTickMilliseconds)
}

/**
 * 逐步提高提醒窗口的不透明度，实现配置时长的淡入效果。
 */
FadeInReminder() {
    global reminderGui, reminderVisible, reminderState, reminderAlpha, displayDurationSeconds

    if !reminderVisible || reminderState != "showing"
        return

    reminderAlpha += 5
    if reminderAlpha >= 255 {
        reminderAlpha := 255
        reminderState := "visible"
        SetTimer(FadeInReminder, 0)

        ; 完全显示后，经过配置的全屏显示时间即自动淡出。
        SetTimer(AutoHideReminder, -(displayDurationSeconds * 1000))
    }
    WinSetTransparent(reminderAlpha, "ahk_id " reminderGui.Hwnd)
}

/**
 * 在提醒无人操作时自动开始淡出。
 */
AutoHideReminder() {
    CloseReminder()
}

/**
 * 关闭当前提醒并执行配置时长的淡出动画。
 *
 * @param args 兼容按钮、窗口事件和 Esc 热键传入的事件参数
 */
CloseReminder(*) {
    global reminderGui, reminderVisible, reminderState, fadeTickMilliseconds

    if !reminderVisible || reminderState = "hiding"
        return

    reminderState := "hiding"
    SetTimer(FadeInReminder, 0)
    SetTimer(AutoHideReminder, 0)
    SetTimer(FadeOutReminder, fadeTickMilliseconds)
}

/**
 * 逐步降低提醒窗口的不透明度；结束后销毁窗口并重新开始下一轮倒计时。
 */
FadeOutReminder() {
    global reminderGui, reminderVisible, reminderState, reminderAlpha, nextIntervalSeconds

    if !reminderVisible
        return

    reminderAlpha -= 5
    if reminderAlpha <= 0 {
        SetTimer(FadeOutReminder, 0)
        reminderGui.Destroy()
        reminderGui := 0
        reminderVisible := false
        reminderState := "hidden"
        reminderAlpha := 0

        ; 只有淡出完成后，才开始下一轮配置间隔倒计时并刷新菜单。
        ScheduleNextReminder()
        return
    }

    WinSetTransparent(reminderAlpha, "ahk_id " reminderGui.Hwnd)
}

; 提醒窗口显示时，也可以按 Esc 关闭它。
#HotIf reminderVisible
Esc::CloseReminder()
#HotIf
