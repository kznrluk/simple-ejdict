# simple-ejdict
パブリックドメインの英和辞書データ "ejdict-hand" を基にしたシンプルな辞書CSV

[English-Japanese Dictionary "ejdict-hand"](https://github.com/kujirahand/EJDict) を `英語,日本語` 形式に変換したCSVファイルと、作成に使用するPowerShell Scriptです。本リポジトリに含まれておりスクリプト内から参照している `ejdict-hand-utf8.txt` は[クジラ飛行様のWEB便利ツール](https://kujirahand.com/web-tools/EJDictFreeDL.php)でパブリックドメインとして提供されているものです。

`mecab` が利用できる環境では名詞のみを出力する `convert_noun_dict.ps1` も利用できます。　

```csv
ribbon,細かく裂けた物
ribbon,リボン
ribbon,手綱
ribcage,肋骨壁
ribose,リボース
ribosome,リボゾーム
rice,米
rice,イネ
rice,ライサーで米粒ほどの太さのそうめん状にする
ricer,ライサー
rich,金持ちの
rich,富んだ
rich,豊かな
```

## 注意
- Windows 11のPowerShell以外での動作検証をしていない
- 不完全だったり破損している行がある
- 元の"ejdict-hand"から消えている情報がある
- `convert_noun_dict.ps1` の利用にはUTF-8でインストールされたmecabが必要である

## 使い方

- CSVを作成する
```
PS C:\Git\simple-ejdict> .\convert_simple_ejdict.ps1
```

- 出来上がったCSVから名詞のみを出力する (mecabコマンド必須)
```
PS C:\Git\simple-ejdict> .\convert_noun_dict.ps1
```

## ライセンス

CC0