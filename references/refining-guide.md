# 提煉流程（spec 的建立與演化）

## 建新專案的 spec（bootstrap）

1. Agent 讀本 skill 的 `spec-format.md`，準備問卷。
2. 從 Apple HIG 取官方錨點與系統規範（見 `apple-platform.md`）：
   anchor、44pt 觸控目標、SF 字級階梯、安全區域。
3. 問設計負責人品味決策：品牌色、字級個性、間距鬆緊、圓角風格。
   只問品味，不問結構。結構由 HIG 和格式決定。
4. 按格式起草 `spec.md`，設計負責人拍板後存到專案目錄。
5. 第一版只求 anchor + 核心 tokens + checklist，能開工就好。
   不要想一次寫完美。

## 演化（開工後）

新元件或新狀態出現時：
1. Agent 按命名規則提案（名稱、數值、用途）。
2. 設計負責人批准。
3. `spec.md` 與 `bin/validate.py` 的檢查規則同步更新，同版本進退。

## 禁止

- 不從舊稿反推 spec。舊稿只當靈感，不抄數字。
  （順序：先立規則，再產出 artifacts。）
- 不憑空發明 token。每個 token 要嘛來自 HIG，要嘛來自設計負責人的品味決策，
  要嘛來自已批准的提案，要有出處。
