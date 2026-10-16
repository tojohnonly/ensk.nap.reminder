# NapReminder

**NapReminder** is a lightweight break-reminder tool for Windows. It runs in the background, shows a full-screen reminder at the configured interval, and displays a live countdown in the notification-area menu.

## Features

- Full-screen break reminders on a configurable schedule.
- Fade-in and fade-out animation. Click **Got it** or press **Esc** while the reminder is visible to dismiss it.
- Automatic dismissal after the configured display time.
- A tray-menu countdown that refreshes every second.
- A dark tray menu with the application icon on its title item.
- Configurable reminder text, timing, and background gradient.

The tray menu contains three items: **NapReminder** (no action), **Next Nap ...** (live countdown, no action), and **Exit**. Zero-valued units are omitted, for example, **Next Nap 1Min** or **Next Nap 3Sec**. When the countdown reaches zero, the item reads **Next Nap**.

## Requirements

- Windows.
- AutoHotkey v2.0 is required to run the source script.
- The dark tray-menu theme uses a Windows theme API available on Windows 10 version 1809 (build 17763) and later. On older versions, the application can still run, but the menu may use the system theme.

## Run

### Compiled application

Run **NapReminder.exe**. Keep the configuration file and icon folder beside the executable so the application can find them:

    NapReminder.exe
    config.ini
    icon/
      NapReminder.ico

### AutoHotkey source

Install AutoHotkey v2 and run **NapReminder.ahk**. The script reads **config.ini** and **icon/NapReminder.ico** from its own directory.

The first reminder appears after the configured interval. After each reminder has been dismissed and faded out, the next interval begins.

## Configuration

Edit the **[Reminder]** section in **config.ini**. Time values are in seconds and must be greater than zero. Missing or invalid time values use the script defaults.

| Setting | Description | Current value |
| --- | --- | ---: |
| **FadeDurationSeconds** | Duration of each fade-in and fade-out | **1** |
| **NextIntervalSeconds** | Interval between reminders | **1800** (30 minutes) |
| **DisplayDurationSeconds** | Time the fully visible reminder stays on screen | **10** |
| **ReminderTitle** | Reminder heading | Japanese text |
| **ReminderMessage** | Reminder body | Japanese text |
| **ButtonText** | Dismiss-button label | Japanese text |
| **GradientColors** | Comma-separated 6-digit RGB hex colors | 12 dark-blue colors |

Blank text values fall back to the Chinese defaults in the script. Invalid gradient entries are ignored; if fewer than two valid colors remain, the built-in gradient is used. Restart the application after changing the configuration.

## Files

- **NapReminder.ahk** — AutoHotkey v2 source.
- **NapReminder.exe** — Compiled Windows application.
- **config.ini** — Reminder timing, text, and gradient settings.
- **icon/NapReminder.ico** — Icon shown beside the tray-menu title.

## Privacy

NapReminder displays reminders locally. It does not require a network connection or collect or transmit usage data.

---

# NapReminder（简体中文）

**NapReminder** 是一款轻量的 Windows 休息提醒工具。程序在后台运行，按设定的间隔显示全屏提醒，并在通知区域菜单中显示实时倒计时。

## 功能

- 按设定的间隔弹出全屏休息提醒。
- 提醒窗口支持淡入、淡出；点击 **知道了**，或在提醒显示时按 **Esc**，即可关闭。
- 到达设定的显示时长后自动关闭。
- 通知区域菜单每秒更新下一次提醒的倒计时。
- 托盘菜单使用深色主题，标题项显示程序图标。
- 可配置提醒文案、时间和背景渐变色。

托盘菜单包含三项：**NapReminder**（点击无操作）、**Next Nap ...**（实时倒计时，点击无操作）和 **Exit**（退出）。分钟或秒为零时会省略该单位，例如 **Next Nap 1Min**、**Next Nap 3Sec**。倒计时归零时显示 **Next Nap**。

## 环境要求

- Windows。
- 运行源码脚本需要 AutoHotkey v2.0。
- 深色托盘菜单使用 Windows 10 版本 1809（Build 17763）及以上系统提供的主题 API。较旧系统仍可运行，但菜单可能使用系统主题。

## 运行

### 运行编译版

运行 **NapReminder.exe**。请将配置文件和图标目录放在可执行文件旁边，以便程序读取：

    NapReminder.exe
    config.ini
    icon/
      NapReminder.ico

### 运行 AutoHotkey 脚本

安装 AutoHotkey v2 后运行 **NapReminder.ahk**。脚本会从自身所在目录读取 **config.ini** 和 **icon/NapReminder.ico**。

启动后，第一轮提醒会在设定的间隔结束后出现。提醒关闭并完成淡出后，才开始计算下一轮间隔。

## 配置

编辑 **config.ini** 中的 **[Reminder]** 配置节。时间单位为秒，必须大于零；时间配置缺失或无效时会使用脚本内置默认值。

| 配置项 | 说明 | 当前值 |
| --- | --- | ---: |
| **FadeDurationSeconds** | 淡入和淡出的时长（各自计算） | **1** |
| **NextIntervalSeconds** | 每轮提醒之间的间隔 | **1800**（30 分钟） |
| **DisplayDurationSeconds** | 提醒完全显示后的停留时间 | **10** |
| **ReminderTitle** | 提醒标题 | 日文文案 |
| **ReminderMessage** | 提醒正文 | 日文文案 |
| **ButtonText** | 关闭按钮文字 | 日文文案 |
| **GradientColors** | 逗号分隔的 6 位 RGB 十六进制颜色 | 12 个深蓝色值 |

文本配置留空时会回退到脚本中的中文默认文案。无效的渐变色会被忽略；有效颜色少于两个时使用内置渐变色。修改配置后请重启程序。

## 文件

- **NapReminder.ahk**：AutoHotkey v2 源码。
- **NapReminder.exe**：已编译的 Windows 程序。
- **config.ini**：提醒时间、文案和渐变色配置。
- **icon/NapReminder.ico**：托盘菜单标题旁显示的图标。

## 隐私

NapReminder 在本机显示提醒，不需要网络连接，也不会收集或发送使用数据。

---

# NapReminder（日本語）

**NapReminder** は Windows 向けの軽量な休憩リマインダーです。バックグラウンドで動作し、設定した間隔で全画面の通知を表示します。通知領域のメニューでは、次の通知までの時間を確認できます。

## 主な機能

- 設定した間隔で全画面の休憩通知を表示します。
- フェードイン・フェードアウトに対応しています。**「わかりました」**をクリックするか、通知表示中に **Esc** キーを押すと閉じます。
- 設定した表示時間が過ぎると自動的に閉じます。
- 通知領域のメニューに次の通知までのカウントダウンを表示し、毎秒更新します。
- トレイメニューはダークテーマで、タイトル項目にアプリのアイコンを表示します。
- 通知文、時間、背景グラデーションを設定できます。

トレイメニューには **NapReminder**（クリックしても何もしません）、**Next Nap ...**（カウントダウン、クリックしても何もしません）、**Exit**（終了）の 3 項目があります。分または秒が 0 の場合は省略され、**Next Nap 1Min**、**Next Nap 3Sec** のように表示されます。0 になると **Next Nap** と表示されます。

## 動作環境

- Windows。
- ソーススクリプトの実行には AutoHotkey v2.0 が必要です。
- ダークトレイメニューには Windows 10 バージョン 1809（ビルド 17763）以降のテーマ API を使用します。それより古い環境でも起動できますが、メニューはシステムテーマで表示される場合があります。

## 起動方法

### コンパイル済みアプリ

**NapReminder.exe** を実行してください。設定ファイルとアイコンフォルダーを実行ファイルと同じ場所に置いてください。

    NapReminder.exe
    config.ini
    icon/
      NapReminder.ico

### AutoHotkey スクリプト

AutoHotkey v2 をインストールし、**NapReminder.ahk** を実行してください。スクリプトは同じフォルダーにある **config.ini** と **icon/NapReminder.ico** を読み込みます。

起動後、最初の通知は設定した間隔が経過してから表示されます。通知が閉じてフェードアウトした後、次の間隔の計測を開始します。

## 設定

**config.ini** の **[Reminder]** セクションを編集してください。時間の単位は秒で、0 より大きい値を指定します。時間の設定がない、または無効な場合はスクリプト内蔵の既定値を使用します。

| 設定項目 | 説明 | 現在の値 |
| --- | --- | ---: |
| **FadeDurationSeconds** | フェードイン・フェードアウトそれぞれの時間 | **1** |
| **NextIntervalSeconds** | 通知間の間隔 | **1800**（30 分） |
| **DisplayDurationSeconds** | 完全表示後の表示時間 | **10** |
| **ReminderTitle** | 通知タイトル | 日本語の文言 |
| **ReminderMessage** | 通知本文 | 日本語の文言 |
| **ButtonText** | 閉じるボタンの文字 | 日本語の文言 |
| **GradientColors** | カンマ区切りの 6 桁 RGB 16 進数カラー | 濃い青系 12 色 |

テキスト設定が空の場合は、スクリプト内蔵の中国語の既定文言に戻ります。無効なグラデーション色は無視され、有効な色が 2 色未満の場合は内蔵グラデーションを使用します。設定変更後はアプリを再起動してください。

## ファイル

- **NapReminder.ahk**：AutoHotkey v2 のソースコード。
- **NapReminder.exe**：コンパイル済み Windows アプリ。
- **config.ini**：通知時間、文言、グラデーションの設定。
- **icon/NapReminder.ico**：トレイメニューのタイトルに表示するアイコン。

## プライバシー

NapReminder はローカルで通知を表示します。ネットワーク接続は不要で、使用データの収集や送信は行いません。

---

# NapReminder（한국어）

**NapReminder**는 Windows용 경량 휴식 알림 도구입니다. 백그라운드에서 실행되며 설정한 간격마다 전체 화면 알림을 표시합니다. 시스템 트레이 메뉴에서 다음 알림까지 남은 시간을 확인할 수 있습니다.

## 주요 기능

- 설정한 간격마다 전체 화면 휴식 알림을 표시합니다.
- 페이드 인·아웃 효과를 지원합니다. **알겠습니다**를 클릭하거나 알림이 표시된 동안 **Esc** 키를 누르면 닫힙니다.
- 설정한 표시 시간이 지나면 자동으로 닫힙니다.
- 트레이 메뉴에 다음 알림까지 남은 시간을 표시하고 매초 갱신합니다.
- 트레이 메뉴는 다크 테마를 사용하며 제목 항목에 앱 아이콘을 표시합니다.
- 알림 문구, 시간, 배경 그라데이션을 설정할 수 있습니다.

트레이 메뉴는 **NapReminder**(클릭해도 동작 없음), **Next Nap ...**(카운트다운, 클릭해도 동작 없음), **Exit**(종료) 세 항목으로 구성됩니다. 분 또는 초가 0이면 생략되어 **Next Nap 1Min**, **Next Nap 3Sec**처럼 표시됩니다. 카운트다운이 0이 되면 **Next Nap**으로 표시됩니다.

## 요구 사항

- Windows.
- 소스 스크립트를 실행하려면 AutoHotkey v2.0이 필요합니다.
- 다크 트레이 메뉴는 Windows 10 버전 1809(빌드 17763) 이상에서 제공하는 테마 API를 사용합니다. 이전 버전에서도 실행할 수 있지만 메뉴는 시스템 테마로 표시될 수 있습니다.

## 실행 방법

### 컴파일된 앱

**NapReminder.exe**를 실행하세요. 설정 파일과 아이콘 폴더를 실행 파일과 같은 위치에 두세요.

    NapReminder.exe
    config.ini
    icon/
      NapReminder.ico

### AutoHotkey 스크립트

AutoHotkey v2를 설치한 뒤 **NapReminder.ahk**를 실행하세요. 스크립트는 같은 폴더의 **config.ini**와 **icon/NapReminder.ico**를 읽습니다.

프로그램 시작 후 설정한 간격이 지나면 첫 알림이 표시됩니다. 알림이 닫히고 페이드 아웃이 끝난 다음부터 다음 간격을 계산합니다.

## 설정

**config.ini**의 **[Reminder]** 섹션을 편집하세요. 시간 단위는 초이며 0보다 큰 값을 사용해야 합니다. 시간 설정이 없거나 유효하지 않으면 스크립트의 기본값을 사용합니다.

| 설정 항목 | 설명 | 현재 값 |
| --- | --- | ---: |
| **FadeDurationSeconds** | 페이드 인과 페이드 아웃 각각의 시간 | **1** |
| **NextIntervalSeconds** | 알림 사이의 간격 | **1800**(30분) |
| **DisplayDurationSeconds** | 완전히 표시된 뒤 유지되는 시간 | **10** |
| **ReminderTitle** | 알림 제목 | 일본어 문구 |
| **ReminderMessage** | 알림 본문 | 일본어 문구 |
| **ButtonText** | 닫기 버튼 문구 | 일본어 문구 |
| **GradientColors** | 쉼표로 구분한 6자리 RGB 16진수 색상 | 짙은 파랑 계열 12개 |

텍스트 설정을 비워 두면 스크립트의 중국어 기본 문구를 사용합니다. 유효하지 않은 그라데이션 색상은 무시하며, 유효한 색상이 2개 미만이면 내장 그라데이션을 사용합니다. 설정을 변경한 뒤 앱을 다시 시작하세요.

## 파일

- **NapReminder.ahk**: AutoHotkey v2 소스 코드.
- **NapReminder.exe**: 컴파일된 Windows 앱.
- **config.ini**: 알림 시간, 문구, 그라데이션 설정.
- **icon/NapReminder.ico**: 트레이 메뉴 제목 옆에 표시되는 아이콘.

## 개인정보 보호

NapReminder는 로컬에서 알림을 표시합니다. 네트워크 연결이 필요하지 않으며 사용 데이터를 수집하거나 전송하지 않습니다.
