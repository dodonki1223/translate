# translate 🇯🇵 → 🇺🇸

このリポジトリは [AWS ハンズオン資料](https://aws.amazon.com/jp/aws-jp-introduction/aws-jp-webinar-hands-on/) の [サーバーレスアーキテクチャで翻訳 Web API を構築する](https://pages.awscloud.com/event_JAPAN_Hands-on-for-Beginners-Serverless-2019_Contents.html) を参考に Terraform と Serverless Framework で書き直したものになります。  

![overall](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/00_overall.png)

## 📄 概要

このリポジトリには大きく分けて３つ目的があり作成しています。

- **Terraform と Serverless Framework の相互連携**
- **サーバーレスアーキテクチャーの Infrastructure as Code（IaC）化**
- **ローカル環境にてサーバーレスアーキテクチャーのエミュレートしながらの開発を可能にする**

基本的にはハンズオン資料で作成したものとほぼ同じになるように作成していますが一部 Lambda レイヤーを導入していたりと少し違っています。  

## ⚙️ 環境構築

AWS のリソースは Terraform で管理されているものと Serverless Framework で管理されているものがあります。  
Terraform の tfstate ファイル（現在の状態を表すファイル）は複数人で開発することを想定しているため AWS S3 に保存して開発を行います。  
また Serverless Framework もデプロイするために AWS S3 を使用する（CloudFormation, Lambda のコードを zip化されたものなどを指す。 .serverless フォルダ配下に作成されているファイル群）ため作成が必要です。  

S3 の作成後、Terraform と Serverless Framework の設定を順番に行っていきます。  
Terraform と Serverless Framework の連携のため、 **設定する順番がとても重要** になってきます。 **必ず Terraform から設定をする必要** があります。

### 🗑 Terraform と Serverless Framework で使用する S3 の作成

S3 作成用のシェルスクリプトがあるため、基本的にはそのシェルスクリプトを実行するだけで大丈夫です。  
[AWS CLI](https://docs.aws.amazon.com/ja_jp/streams/latest/dev/kinesis-tutorial-cli-installation.html) を使用してバケットを作成するので、 [AWS CLI](https://docs.aws.amazon.com/ja_jp/streams/latest/dev/kinesis-tutorial-cli-installation.html) が実行できる状態にしておいてください。  
必ず profile の指定が必要なので profile の作成も行う必要があります。

profile の作成方法に関しては以下のコマンドを実行してください。

```shell
$ aws configure --profile terraform
```

実際に S3 作成用のシェルスクリプトを実行した時の例になります。

```shell
dodonki1223🐻: ~/project/translate on 🌱 main [📝🤷‍✓] took 10s
└─> bin/init_s3.sh
S3バケット作成で使用するprofile名を入力してください: terraform
tfstateもしくはServerless FrameworkのデプロイS3バケット名を入力して下さい: translate-sls
translate-slsの作成を行います
make_bucket: translate-sls
translate-slsにバージョンニングを有効化に成功しました
translate-slsにサーバー側の暗号化を有効化に成功しました
translate-slsのアクセスの変更に成功しました
```

このリポジトリでは profile 名と バケット名は固定でソースコードに書かれているので適宜変更してください。

| 設定名                                  | 設定値              |
|:----------------------------------------|:--------------------|
| AWS の profile 名                       | terraform           |
| tfstate の格納バケット                  | translate-terraform |
| Serverless Framework デプロイ用バケット | terraform-sls       |

### 🌭 Terraform の環境構築

ローカル環境であっても **Serverless Framework と連携** するために **AWS Systems Manager Parameter Store を使用する必要がある** ため、予め開発用のパラメータをセットしておく必要があります。  
なので Serverless Framework の開発を始める前にまずは AWS に必要なリソースを Terraform を使って作成していきます。

これからの作業は **terraform のディレクトリで行う** ので必ず移動してください。

```shell
$ cd translate/terraform
```

#### Terraform をインストールする

asdf などのパッケージマネージャーを使用して Terraform をインストールして使える状態にします。

```shell
# terraform の plugin を追加する
$ asdf plugin add terraform
updating plugin repository...remote: Enumerating objects: 41, done.
remote: Counting objects: 100% (41/41), done.
remote: Compressing objects: 100% (36/36), done.
remote: Total 41 (delta 22), reused 14 (delta 5), pack-reused 0
Unpacking objects: 100% (41/41), 40.13 KiB | 334.00 KiB/s, done.
From https://github.com/asdf-vm/asdf-plugins
   8ef69e3..fe90d7a  master     -> origin/master
HEAD is now at fe90d7a feat: add asdf-gcc-arm-none-eabi plugin (#565)

# terraform をインストールする
$ asdf install terraform
```

#### Terraform の初期化コマンドを実行する

terraform 内で使用している plugin などのバイナリファイルをダウンロードします。

```shell
$ terraform init 
```

#### workspace を作成する

環境の切り分けについてはそれぞれの環境で差異があるわけではないので workspace を使うことを前提としています。  
dev, stg, prod の環境をそれぞれ作成しておくと良いでしょう。

注意：workspace は必ず `dev` 環境を作成しないとローカル実行もできないです！

```shell
$ terraform workspace new dev
Created and switched to workspace "dev"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
```

#### 作成した workspace を選択する

```shell
$ terraform workspace select dev
Switched to workspace "dev".
```

#### Terraform で AWS のリソースを作成する

```shell
$ terraform apply -parallelism=30
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
・
・
・
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
```

### 🍔 Serverless Framework の環境構築

Serverless Framework は基本的に Docker で開発を行うため、Docker が使える状態にしておいてください。

これからの作業は **serverless のディレクトリ** で行うので必ず移動してください。

```shell
$ cd translate/serverless
```

#### 環境変数を設定する

テンプレートファイルをコピーし環境変数を設定します。

```shell
$ cp .docker/.env.sample .docker/.env
```

| 環境変数名            | 説明                                                                                      |
|:----------------------|:------------------------------------------------------------------------------------------|
| AWS_ACCESS_KEY_ID     | IAM ユーザーまたはロールに関連付けられる AWS アクセスキー                                 |
| AWS_SECRET_ACCESS_KEY | AWS アクセスキーに関連付けられているシークレットキー（AWS アクセスキーのパスワードのこと）|
| AWS_REGION            | profile 設定のリージョン設定                                                              |
| DYNAMODB_LOCAL_PORT   | ローカルで実行している DynamoDB Local へアクセスするためのポート番号                      |

#### 開発環境を立ち上げる

Docker のコマンドを実行し開発環境を立ち上げます。

```shell
$ docker-compose up
・
・
・
offline_1         | Server ready: http://0.0.0.0:3000 🚀
```

[http://localhost:3000/dev/translate?input_text=おはよう](http://localhost:3000/dev/translate?input_text=おはよう) へアクセスし `Good morning` と返ってくれば API Gateway, Lambda, DynamoDB のローカル実行が出来ています。

![translate_web_api_result](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/03_translate_web_api_result.png)

また [http://localhost:8001](http://localhost:8001) にアクセスし dynamodb-admin が表示されていることも確認しておきましょう。

![dynamodb_admin](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/04_dynamodb_admin.png)

これでローカルの環境構築完了です！

## ⚔️ Terraform と Serverless Framework について

![relationship_between_terraform_and_serverless_framework](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/01_relationship_between_terraform_and_serverless_framework.png)

開発に入る前にまずはこのリポジトリでの Terraform と Serverless Framework についての説明をします。  
AWS のリソースに関しては **Terraform が管理しているもの** と **Serverless Framework が管理しているもの** があります。

### 🌭 Terraform の管理化リソース

Terraform が管理しているリソースは **IAM ロール, パラメータストア** になります。  
権限は Serverless Framework で管理せずに Terraform で管理しています。

![terraform_resources](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/05_terraform_resources.png)

### 🍔 Serverless Framework の管理化リソース

Serverless Framework が管理しているリソースは **API Gateway, Lambda, DynamoDB, CloudWatch Logs** になります。

![serverless_framework](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/06_serverless_framework_resources.png)

### 🌭 Terraform と 🍔 Serverless Framework の連携について

Terraform と Serverless Framework の連携に関してですが **「Terraform → Serverless Framework」** と **「Serverless Framework → Terraform」** の２種類がありそれぞれちゃんと連携を考えないといけません。  
連携するためにデプロイ順もちゃんと考慮する必要があるのでどうやって連携するのかということだけをちゃんと理解出来るようになっていれば応用がきくのでしっかりと概念を頭に入れておくとよいでしょう。  

このリポジトリでは「Terraform → Serverless Framework」の連携だけ実装されています。ただしサンプルとして「Serverless Framework → Terraform」も連携出来ることも確認済みなのでいつでも連携可能です。

### 🌭 Terraform → 🍔 Serverless Framework 連携

Serverless Framework の公式サイトに Terraform との連携方法について書かれている記事がありそれを参考にして連携しています。  
Terraform で作成したリソースの arn をパラメータストアに設定し設定したパラメータストアから arn を取得して Serverless Framework で使用します。

serverless.yml のソースコード上だと以下のような記述で連携しています。

```yml
custom:
  iamRoleName: ${ssm:/translate/iam_role/lambda_function_${sls:stage}}
```

詳しくは以下の記事を参考にしてください。

- [The definitive guide to using Terraform with the Serverless Framework](https://www.serverless.com/blog/definitive-guide-terraform-serverless/)

### 🍔 Serverless Framework → 🌭 Terraform 連携

Serverless Framework は CloudFormation を使用してデプロイするので CloudFormation が出力した output を使用して Terraform で連携させます。  
aws_cloudformation_export を使用することで CloudFormation が出力した情報を読み込むことができるようになるので Terraform でも連携が可能になります。

```terraform 
data "aws_cloudformation_export" "lambda_function_arn" {
  name = format("lambda-function-arn-%s", terraform.workspace)
}
```

## 💻 開発

開発は Terraform と Serverless Framework によって方法が違うため、注意して下さい。  
Serverless Framework に関しては複数の開発方法があるため、好みによって使い分けて下さい。

### 🌭 Terraform

開発環境の構築が終わっていればそのまま開発することができます。  

Terraform の開発は `translate/terraform` のディレクトリに移動し、Terraform の通常通りの開発と同じく `terraform init`, `terraform plan`, `terraform apply` などのコマンドを使用して開発を行って下さい。

### 🍔 Serverless Framework

![local_development_environment](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/02_local_development_environment.png)

Serverless Framework の開発は２通りあります。  
Docker のコンテナ内で開発することは変わらないのですが、VSCode を使った **[Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) での開発** と **開発用のコンテナにログインして開発** する方法があります。

Serverless Framework の開発は translate/serverless のディレクトリに移動して開発を行います。

#### なぜ Docker を使って開発を行っているのか？

**DynamoDB Local が M1 Mac だと動作しなかった** ため仕方なく Docker 化して開発することにしました。
DynamoDB Local で使用されている SQLLite のライブラリが arm64 に対応していないため M1 Mac での動作が出来ないためです。  

ただ現在では Serverless Framework で DynamoDB Local を使用する [plugin が Docker に対応した](https://github.com/99x/dynamodb-localhost/issues/63) ため Docker 化しなくても動作するようになった（未検証です）かもしれません。

#### VSCode Remote Containers

![remote_containers](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/07_remote_containers.gif)

VSCode の拡張機能である **[Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) を予めインストール** しておいてください。  
gif を見る通り Remote Containers を使用し offline コンテナを起動して offline コンテナ内で開発を行います。

#### 開発用コンテナ

docker-compose.yml に開発用のサービスを定義してあります。  
`docker-compose up` のコマンドでは立ち上がらないように profiles の指定をしているので明示的に開発用のサービスを指定することで開発用のコンテナが立ち上がります。

```shell
$ docker-compose run --rm runner
```

## 🚀 デプロイ

デプロイは Terraform と Serverless Framework の２つがあります。  
このリポジトリではデプロイ順はすごく大切なことなので **必ずデプロイ順を間違えず** に行いましょう。

### 🚨 デプロイ順に関して

**Serverless Framework は Terraform のリソースに依存** しています。なのでデプロイする時は **必ず Terraform から行う必要** があります。

Serverless Framework からデプロイしようとするとエラーになり失敗します。

### 🌎 デプロイ環境に関して

デプロイ環境ですが、以下の環境を想定して作成してあります。

| 環境 | 説明             |
|:----:|:-----------------|
| dev  | 開発環境         |
| stg  | ステージング環境 |
| prod | 本番環境         |

### 🌭 Terraform

まずは terraform ディレクトリに移動して下さい。

```shell
$ cd translate/terraform
```

デプロイ対象の workspace を選択します。

```shell
$ terraform workspace select prod
Switched to workspace "prod".
```

デプロイコマンドを実行します。

```shell
$ terraform apply -parallelism=30
```

Terraform によるデプロイはこれで終了です。

### 🍔 Serverless Framework

まずは serverless ディレクトリに移動して下さい。

```shell
$ cd translate/serverless
```

開発用コンテナを実行します。

```shell
$ docker-compose run --rm runner
```

デプロイコマンドを実行します。  
`--stage xxx` のパラメータを元にどの環境にデプロイするかが決まります。

開発環境はローカル実行する時に `DYNAMODB_ENDPOINT` が `http://localhost:${env:DYNAMODB_LOCAL_PORT}` になるようにしているため、デプロイ時は明示的に `DYNAMODB_ENDPOINT` を指定することでデプロイを行います。

```
# 開発環境へのデプロイ
$ DYNAMODB_ENDPOINT=https://dynamodb.ap-northeast-1.amazonaws.com yarn deploy --stage dev

# ステージング環境へのデプロイ
$ yarn deploy --stage stg

# 本番環境へのデプロイ
$ yarn deploy --stage prod
```

Serverless Framework によるデプロイはこれで終了です。

## 📕 その他

ちなみにですが [AWS ハンズオン資料](https://aws.amazon.com/jp/aws-jp-introduction/aws-jp-webinar-hands-on/) に [AWS SAM を使ってテンプレートからサーバーレスな環境を構築する](https://pages.awscloud.com/event_JAPAN_Ondemand_Hands-on-for-Beginners-Serverless-2_CP.html) というハンズオン資料が既にあり SAM を使用して Infrastructure as Code（IaC）化されています。  
