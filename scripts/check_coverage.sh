#!/bin/bash
# ---------------------------------------------------------------------------
# check_coverage.sh — lcov.info を解析してカバレッジを報告するスクリプト
#
#   閾値:
#     - 80% 未満 → エラー (exit 1)
#     - 80% 以上 90% 未満 → 警告
#     - 90% 以上 → 合格
# ---------------------------------------------------------------------------

set -euo pipefail

COVERAGE_FILE="${1:-coverage/lcov.info}"
MIN_COVERAGE=80
TARGET_COVERAGE=90

# ---------------------------------------------------------------------------
# lcov.info の存在チェック
# ---------------------------------------------------------------------------
if [ ! -f "$COVERAGE_FILE" ]; then
  echo "::error::カバレッジファイルが見つかりません: $COVERAGE_FILE"
  echo "先に 'flutter test --coverage' を実行してください。"
  exit 1
fi

# ---------------------------------------------------------------------------
# lcov.info を解析してファイルごとのカバレッジを計算
# ---------------------------------------------------------------------------
echo "========================================"
echo " カバレッジレポート"
echo "========================================"
echo ""

total_lines=0
total_hits=0
current_file=""
file_lines=0
file_hits=0

# ファイルごとの結果を一時保存
declare -a file_reports=()

while IFS= read -r line; do
  case "$line" in
    SF:*)
      current_file="${line#SF:}"
      file_lines=0
      file_hits=0
      ;;
    LF:*)
      file_lines="${line#LF:}"
      ;;
    LH:*)
      file_hits="${line#LH:}"
      ;;
    end_of_record)
      if [ -n "$current_file" ] && [ "$file_lines" -gt 0 ]; then
        file_pct=$((file_hits * 100 / file_lines))
        # lib/ 以降のパスのみ表示
        display_path="${current_file#*lib/}"
        if [ "$display_path" = "$current_file" ]; then
          display_path="$current_file"
        else
          display_path="lib/$display_path"
        fi

        # 状態アイコン
        if [ "$file_pct" -lt "$MIN_COVERAGE" ]; then
          icon="[NG]"
        elif [ "$file_pct" -lt "$TARGET_COVERAGE" ]; then
          icon="[!!]"
        else
          icon="[OK]"
        fi

        file_reports+=("$(printf "  %s %3d%% (%d/%d) %s" "$icon" "$file_pct" "$file_hits" "$file_lines" "$display_path")")
        total_lines=$((total_lines + file_lines))
        total_hits=$((total_hits + file_hits))
      fi
      current_file=""
      ;;
  esac
done < "$COVERAGE_FILE"

# ---------------------------------------------------------------------------
# ファイルごとのカバレッジを表示
# ---------------------------------------------------------------------------
echo "ファイル別カバレッジ:"
echo "----------------------------------------"
for report in "${file_reports[@]}"; do
  echo "$report"
done
echo "----------------------------------------"
echo ""

# ---------------------------------------------------------------------------
# 全体カバレッジの計算と報告
# ---------------------------------------------------------------------------
if [ "$total_lines" -eq 0 ]; then
  echo "::error::カバレッジデータが空です。テストが正しく実行されたか確認してください。"
  exit 1
fi

total_pct=$((total_hits * 100 / total_lines))

echo "========================================"
printf " 全体カバレッジ: %d%% (%d/%d 行)\n" "$total_pct" "$total_hits" "$total_lines"
echo "========================================"
echo ""
echo " 最低ライン: ${MIN_COVERAGE}%"
echo " 目標ライン: ${TARGET_COVERAGE}%"
echo ""

# ---------------------------------------------------------------------------
# 閾値チェック
# ---------------------------------------------------------------------------
if [ "$total_pct" -lt "$MIN_COVERAGE" ]; then
  echo "::error::カバレッジが最低ライン(${MIN_COVERAGE}%)を下回っています: ${total_pct}%"
  echo "[NG] カバレッジ不足です。テストを追加してください。"
  exit 1
elif [ "$total_pct" -lt "$TARGET_COVERAGE" ]; then
  echo "::warning::カバレッジが目標ライン(${TARGET_COVERAGE}%)を下回っています: ${total_pct}%"
  echo "[!!] 目標未達ですが、最低ラインはクリアしています。"
  exit 0
else
  echo "[OK] カバレッジは目標ライン(${TARGET_COVERAGE}%)を達成しています。"
  exit 0
fi
