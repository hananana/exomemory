# Exomemory

認知科学ベースの外部記憶プラグイン for Claude Code。

人間の記憶の4段階 — **符号化**・**保持**・**忘却**・**想起** — をAIエージェントの長期知識管理として実装します。

> [English version](./README.en.md)

## 特徴

- **3種類の記憶** — 認知科学の分類（Tulving, 1972）に基づく:
  - **エピソード記憶** — 日付付きの出来事・議論・気づき（TTL: 90日）
  - **意味記憶** — 再利用可能なルール・フレームワーク・意思決定記録（無期限）
  - **手続き記憶** — 作業スタイル・好み・行動パターン（変更まで永続）
- **R×I×R スコアリング** による想起: Recency（鮮度）× Importance（重要度）× Relevance（関連度）
- **自動忘却** — TTLベースの失効と月次メンテナンス（セッション開始時に自動チェック）
- **記憶の昇格** — 頻繁に参照されるエピソード記憶を意味記憶に固定化
- **SessionStart フック** — セッション開始時に記憶インデックスを自動読み込み

## インストール

### マーケットプレイス経由（推奨）

Claude Code の設定ファイル（`~/.claude/settings.json`）にマーケットプレイスを追加:

```json
{
  "extraKnownMarketplaces": {
    "exomemory": {
      "source": {
        "source": "github",
        "repo": "hananana/exomemory"
      }
    }
  }
}
```

プラグインをインストール:

```
/plugin install exomemory@exomemory
```

### アップデート

```
/plugin update exomemory@exomemory
```

更新後は Claude Code の再起動が必要です。

### 初回セットアップ

インストール後、以下を実行して記憶ディレクトリを初期化:

```
/exomemory:memory-setup
```

`~/.local/share/exomemory/` に記憶ファイル群が作成されます。

## 使い方

### 記憶する

```
/exomemory:remember <覚えたい内容>
```

内容に応じて適切な記憶タイプ（エピソード・意味・手続き）に自動分類して保存します。

### 思い出す

```
/exomemory:recall <思い出したいこと>
```

R×I×R スコアリングで関連する記憶を検索・取得します。参照されたエピソード記憶の `refs` カウントは自動的に更新されます。

### 月次メンテナンス

セッション開始時に前回のメンテナンスから30日以上経過していると、自動的にメンテナンスが実行されます。手動で実行する場合:

```
/exomemory:memory-maintenance
```

実行内容:
- TTL切れエントリのアーカイブ（90日超）
- 頻繁に参照されるエピソード記憶の意味記憶への昇格
- 古い冗長なエントリの圧縮
- インデックスの整合性チェック

`--dry-run` で変更せずにプレビュー:

```
/exomemory:memory-maintenance --dry-run
```

## 記憶ディレクトリ構造

```
~/.local/share/exomemory/
├── MEMORY.md                 # インデックス（想起のエントリポイント）
├── episodic/
│   └── context-log.md        # エピソード記憶（時系列の出来事・議論）
├── semantic/
│   ├── frameworks.md          # 意味記憶（ルール・パターン）
│   └── decisions.md           # 意味記憶（意思決定記録）
├── procedural/
│   └── preferences.md         # 手続き記憶（作業スタイル・好み）
└── archive/                   # アーカイブ（TTL切れエントリ、月別）
```

## リポジトリ構造

```
exomemory/
├── .claude-plugin/
│   └── marketplace.json        # マーケットプレイス定義
├── plugins/
│   └── exomemory/
│       ├── .claude-plugin/
│       │   └── plugin.json     # プラグインマニフェスト
│       ├── hooks/
│       │   └── hooks.json      # SessionStart フック定義
│       ├── hooks-handlers/
│       │   └── session-start.sh
│       ├── skills/
│       │   ├── remember/       # /exomemory:remember（記憶の保存）
│       │   ├── recall/         # /exomemory:recall（記憶の想起）
│       │   ├── memory-maintenance/  # /exomemory:memory-maintenance
│       │   └── memory-setup/   # /exomemory:memory-setup
│       └── templates/          # 初回セットアップ用テンプレート
└── README.md
```

## 参考文献

- [認知科学でAI秘書の記憶を再設計したら別人になった話](https://note.com/hatakejp/n/naae38195e8d8) — 設計のインスピレーション元
- Atkinson & Shiffrin (1968) — 多重貯蔵モデル
- Tulving (1972) — エピソード記憶と意味記憶
- Park et al. (2023) — Generative Agents (Stanford) — R×I×R スコアリング

## ライセンス

MIT
