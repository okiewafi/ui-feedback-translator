# spec.md 格式定義

每個專案一份 `spec.md`，放在專案目錄（例如 `~/workspace/<project>/spec.md`），
開工時當參數傳入。格式如下。

## anchor（必填，第一行）

單一 canonical 畫布尺寸，pt 制。validator 讀這行。

```
anchor: 390x844
```

iOS 專案用 `390x844`，Watch 專案用 `198x242`。一個專案一個 anchor，
不混用。詳見 `apple-platform.md`。

## design tokens

### color
每個 token 一行：名稱 + hex + 用途一句話。

```
color-primary: #007AFF    # 主按鈕、連結
color-background: #FFFFFF # 頁面底
```

### type
字級階梯：名稱 + pt + weight + 用途。優先對照 SF 階梯命名
（largeTitle 34、title1 28、title2 22、title3 20、headline 17 semibold、
body 17、callout 16、subheadline 15、footnote 13、caption1 12、caption2 11）；
專案自訂的加前綴。

### spacing
刻度制，4pt 倍數：

```
spacing-1: 4pt
spacing-2: 8pt
spacing-3: 12pt
spacing-4: 16pt
spacing-6: 24pt
spacing-8: 32pt
```

版面只允許使用刻度值。

### radius / shadow
同上命名規則，一行一名稱一數值一用途。

## components

元件名稱 + 變體（variant）+ 各變體引用的 tokens。

```
button/primary: bg color-primary, text white, text-style headline, radius-medium, min-height 44pt
card/default: bg color-card, radius-large, padding spacing-4
```

## edge-state checklist

每個畫面必考四題：空資料、載入中、錯誤、超長文字。
validator 檢查輸出是否覆蓋；沒覆蓋的不交件。

## 命名規則

- 小寫 + 連字號（`spacing-4`，不是 `spacing_4`）。
- token 一經發布不改名，只新增；棄用的標 `deprecated`，不刪除。
- 品味決策（用哪個藍、標題多粗）由設計負責人定，agent 只提案。
