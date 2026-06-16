# ============================================================
# Event Meishi App → GitHub + Render デプロイスクリプト
# ============================================================
# 使い方：
#   1. このフォルダ（deploy/）の中で右クリック → 「PowerShellで実行」
#   2. GitHubユーザー名を聞かれるので入力
#   3. GitHubでリポジトリ作成ページが開く → 「event-meishi-app」を入力して Create（READMEなどはチェックしない）
#   4. このスクリプトに戻ってEnter → 自動でpush
#   5. Renderダッシュボードが開く → 「New + → Static Site」→ リポジトリ選んで「Create」
# ============================================================

Set-Location $PSScriptRoot

Write-Host ""
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "  Event Meishi App / Render デプロイ" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

# 1. GitHubユーザー名
$ghUser = Read-Host "GitHub ユーザー名を入力してください"
if (-not $ghUser) { Write-Host "中止します" -ForegroundColor Red; exit 1 }

$repoName = "event-meishi-app"
$remoteUrl = "https://github.com/$ghUser/$repoName.git"

Write-Host ""
Write-Host "  リポジトリ URL: $remoteUrl" -ForegroundColor Yellow
Write-Host ""

# 2. GitHub の新規リポジトリ作成ページを開く
Write-Host "Step 1/3: GitHubで新規リポジトリを作成してください..."
Write-Host "  リポジトリ名: $repoName"
Write-Host "  ※ Public/Private どちらでもOK"
Write-Host "  ※ README/.gitignore/license は何もチェックしないでください（空リポジトリにする）"
Write-Host ""
Start-Process "https://github.com/new?name=$repoName"
Write-Host "  リポジトリを作成し終わったら、ここに戻ってください。"
Read-Host "  作成完了したら Enter を押してください"

# 3. remote 追加 (既存なら上書き) + push
Write-Host ""
Write-Host "Step 2/3: GitHubに push します..."
git remote remove origin 2>$null | Out-Null
git remote add origin $remoteUrl
git branch -M main
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ push に失敗しました。" -ForegroundColor Red
    Write-Host "   認証エラーの場合は、GitHubのPersonal Access Tokenが必要です。"
    Write-Host "   https://github.com/settings/tokens で repo スコープのトークン発行 →"
    Write-Host "   パスワード代わりに入力してください。"
    exit 1
}

# 4. Render ダッシュボードを開く
Write-Host ""
Write-Host "Step 3/3: Render で Static Site を作成します..." -ForegroundColor Green
Write-Host "  Render が開きます → 「New + → Static Site」"
Write-Host "  → GitHub連携 → $ghUser/$repoName を選択"
Write-Host "  → 設定は何も変えず「Create Static Site」"
Write-Host "  → 数十秒で https://event-meishi-app.onrender.com に公開"
Write-Host ""
Start-Process "https://dashboard.render.com/new/static"

Write-Host ""
Write-Host "✓ push 完了。Render で Create Static Site するだけ。" -ForegroundColor Green
Write-Host ""
Read-Host "Enter で終了"
