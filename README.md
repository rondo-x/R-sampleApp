# R-sampleApp
- CircleCIで下記のworkflowを実行するサンプルリポジトリ

## workflow
1. リポジトリにコードをpush
2. CircleCIがリポジトリにpushされたことをイベントトリガとしてworkflowを実行
3. workflow①: terraformを実行
4. workflow②: ansibleを実行
5. workflow③: serverspecで自動テストを実行
