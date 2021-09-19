# matsuu/wsl-isucon11-final

## これはなに

ISUCON11本選の環境をWSL2上に構築するスクリプトです。

## 構築

PowerShell上で以下を実行します。

```
# ダウンロード
git clone https://github.com/matsuu/wsl-isucon11-final.git

# ディレクトリに移動
cd wsl-isucon11-final

# 一時的にPowerShell実行を許可
Set-ExecutionPolicy RemoteSigned -Scope Process

# 構築スクリプト実行(引数はDistro名、インストールパス)
.\build.ps1 isucon11-final ..\isucon11-final
```

## 実行

```
wsl.exe -d isucon11-final
```

### サイト表示確認

https://localhost/

### ベンチマーク実行

```
cd ~/benchmarker
./bin/benchmarker -target localhost:443 -tls
```

## 関連

* [ISUCON11本選問題](https://github.com/isucon/isucon11-final)
* [matsuu/wsl-isucon](https://github.com/matsuu/wsl-isucon)

## TODO

* エラー制御
  * 二重実行の防止
* `/etc/resolv.conf` 周りの調整
* PowerShellなんもわからん
