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
- **自動忘却** — TTLベースの失効と月次メンテナンス
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

### 開発用

```bash
claude --plugin-dir /path/to/exomemory/plugins/exomemory
```

変更を反映するには `/reload-plugins` を実行。

### 初回セットアップ

インストール後、以下を実行して記憶ディレクトリを初期化:

```
/exomemory:memory-setup
```

`~/.local/share/exomemory/` に記憶ファイル群が作成されます。

## 使い方

### 自動想起

`memory-recall` スキルは、過去の議論・決定・経験に言及したときに自動でトリガーされます。MEMORY.md のインデックスを読み、R×I×R スコアリングで関連する記憶を取得します。

### 月次メンテナンス

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
│       │   ├── memory-recall/  # 自動想起（R×I×R スコアリング）
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
