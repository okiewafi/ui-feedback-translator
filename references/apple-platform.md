# Apple 平台基準（共用知識庫）

## Canonical anchors（pt 制，validator 的比對基準）

| 裝置 | pt | scale | px |
|---|---|---|---|
| iOS（6.1"–6.9" iPhone） | 390×844 | @3x | 1170×2532 |
| Watch 45mm | 198×242 | @2x | 396×484 |

一個專案一個 anchor，不混用。spec.md 第一行宣告，validator 照宣告驗。
新機種每年出，不在此維護全裝置表；基準以上面兩行為準，
新裝置出現時對照 HIG 更新。

## pt / px 換算

- pt × scale = px。iPhone @3x，Watch @2x。
- 切圖輸出：1x / 2x / 3x 各一份；向量（SVG）優先於點陣。

## 觸控與版面鐵律

- 最小觸控目標 44×44 pt。
- 尊重安全區域（safe area）；iOS 6.1"–6.9" 比例一致，以 390×844 為最小基準。
- Watch 按最大尺寸（198×242）設計，關鍵頁面另在 162×197（40mm）
  驗證字級可讀、按鈕可點。

## SF 字級階梯（pt）

largeTitle 34 / title1 28 / title2 22 / title3 20 /
headline 17 semibold / body 17 / callout 16 /
subheadline 15 / footnote 13 / caption1 12 / caption2 11

支援 Dynamic Type；字級 token 命名對照此階梯。

## 參考

- Apple Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/
- 本文件只收與生成、驗證相關的基準；HIG 全文不抄。
