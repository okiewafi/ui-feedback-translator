# ui-feedback-translator（UI 回饋翻譯器）

讓 AI 產出的 App UI 精準且穩定。

## 核心想法

自然語言是願望，數字才是合約。傳統流程敢讓線框圖畫得粗糙，是因為執行者是人，人有常識填補落差；AI 沒有，只能硬湊或幻覺。這個 skill 把人的常識變成機器可執行的約束：

- **開工前**：spec 契約先行，沒有 spec 不開工
- **生成時**：self-validate，附 validator 腳本擋掉不合規的輸出
- **回饋時**：意圖複述成 spec diff，確認後再重畫
- **品味題**：一律出 2–3 個變體讓人選，不賭單一答案

## 內容

```
├── SKILL.md                  # 主檔：四個操作與行為規則
├── references/
│   ├── spec-format.md        # spec.md 格式：anchor、tokens、元件、checklist、命名規則
│   ├── refining-guide.md     # 提煉流程：起草 → 問品味 → 拍板 → 存檔；演化同路
│   ├── feedback-protocol.md  # 回饋協議：機械講解法、品味講問題、意圖複述、變體策略
│   └── apple-platform.md     # Apple 平台基準：390×844、198×242、pt/px、44pt、SF 字級
├── bin/
│   └── validate.py           # validator：檢查 anchor 尺寸與 spec 章節完整性
├── assets/
│   └── spec-template.md      # 空白 spec 模板
└── install.sh                # 安裝與開新專案 scaffolding
```

## 安裝

```bash
# 下載後先看過再跑
curl -fsSL https://raw.githubusercontent.com/okiewafi/ui-feedback-translator/v1.0.0/install.sh -o /tmp/install-uft.sh
less /tmp/install-uft.sh
bash /tmp/install-uft.sh --tag v1.0.0 --project-dir ~/my-app
```

參數：

- `--repo`：skill 的 git repo（預設本 repo，可用 `UI_FEEDBACK_TRANSLATOR_REPO` 環境變數覆蓋）
- `--tag`：版本（建議鎖 tag；不給則自動用最新 tag）
- `--project-dir`：要 scaffolding `spec.md` 的專案目錄（已存在的 `spec.md` 不會被覆蓋）
- `--skills-dir`：agent 找 skill 的目錄（預設 `~/workspace/skills`）

裝好後：skill 進 `<skills-dir>/ui-feedback-translator`，專案目錄多一個 `spec.md` 模板，
`AGENTS.md` 會加一行指標（沒 spec 不開工）。

## 在 ChatGPT 使用

側邊欄 **Plugins** → **Skills** → **Create** → **Upload from your computer**，
把整個目錄包成 zip 上傳。裝好後 ChatGPT 會在相關時自動使用。

（Skills 功能依 OpenAI 方案與 workspace 設定提供，詳見 OpenAI Help Center
「Skills in ChatGPT」。）

## 設計原則

- skill 只裝通用規則（印表機），`spec.md` 住各專案目錄（紙）。
- spec 來源：Apple HIG + 設計負責人的品味，不從舊稿反推。
- 線框圖只約束版面邏輯，精準度住在 tokens 裡。

## License

MIT
