#!/bin/bash

# 源目录（Claude Code 配置所在位置）
SOURCE_DIR="$HOME/.claude"

# 目标目录（当前目录）
TARGET_DIR="$(pwd)"

echo "同步来源: $SOURCE_DIR"
echo "同步目标: $TARGET_DIR"
echo "---"

# 同步 CLAUDE.md
if [ -f "$SOURCE_DIR/CLAUDE.md" ]; then
  cp "$SOURCE_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
  echo "✓ CLAUDE.md"
else
  echo "✗ CLAUDE.md 不存在，跳过"
fi

# 同步 agents 目录
if [ -d "$SOURCE_DIR/agents" ]; then
  rsync -av --delete "$SOURCE_DIR/agents/" "$TARGET_DIR/agents/"
  echo "✓ agents/"
else
  echo "✗ agents/ 不存在，跳过"
fi

# 同步 skills 目录
if [ -d "$SOURCE_DIR/skills" ]; then
  rsync -av --delete "$SOURCE_DIR/skills/" "$TARGET_DIR/skills/"
  echo "✓ skills/"
else
  echo "✗ skills/ 不存在，跳过"
fi

echo "---"
echo "同步完成"