# translate

このリポジトリは [AWS ハンズオン資料](https://aws.amazon.com/jp/aws-jp-introduction/aws-jp-webinar-hands-on/) の [サーバーレスアーキテクチャで翻訳 Web API を構築する](https://pages.awscloud.com/event_JAPAN_Hands-on-for-Beginners-Serverless-2019_Contents.html) を参考に Terraform と Serverless Framework で書き直したものになります。  

![overall](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/00_overall.png)

## 概要

このリポジトリには大きく分けて３つ目的があり作成しています。

- Terraform と Serverless Framework の相互連携
- サーバーレスアーキテクチャーの Infrastructure as Code（IaC）化
- ローカル環境にてサーバーレスアーキテクチャーのエミュレートしながらの開発を可能にする

基本的にはハンズオン資料で作成したものとほぼ同じになるように作成していますが一部 Lambda レイヤーを導入していたりと少し違っています。  

## 環境構築

AWS のリソースは Terraform で管理されているものと Serverless Framework で管理されているものがあります。  
Terraform の tfstate ファイル（現在の状態を表すファイル）は複数人で開発することを想定しているため AWS S3 に保存して開発を行います。  
また Serverless Framework もデプロイするために AWS S3 を使用する（CloudFormation, Lambda のコードを zip化されたものなどを指す。 .serverless フォルダ配下に作成されているファイル群）ため作成が必要です。  

S3 の作成後、Terraform と Serverless Framework の設定を順番に行っていきます。  
Terraform と Serverless Framework の連携のため、 **設定する順番がとても重要** になってきます。 **必ず Terraform から設定をする必要** があります。

### Terraform と Serverless Framework で使用する S3 の作成

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

### Terraform の環境構築

ローカル環境であっても Serverless Framework と連携するために AWS Systems Manager Parameter Store を使用する必要があるため、予め開発用のパラメータをセットしておく必要があります。  
なので Serverless Framework の開発を始める前にまずは AWS に必要なリソースを Terraform を使って作成していきます。

これからの作業は terraform のディレクトリで行うので必ず移動してください。

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

### Serverless Framework の環境構築

Serverless Framework は基本的に Docker で開発を行うため、Docker が使える状態にしておいてください。

これからの作業は serverless のディレクトリで行うので必ず移動してください。

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

## Terraform と Serverless Framework について

![relationship_between_terraform_and_serverless_framework](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/01_relationship_between_terraform_and_serverless_framework.png)

開発に入る前にまずはこのリポジトリでの Terraform と Serverless Framework についての説明をします。  
AWS のリソースに関しては Terraform が管理しているものと Serverless Framework が管理しているものがあります。

### Terraform の管理化リソース

Terraform が管理しているリソースは IAM ロール, パラメータストアになります。  
権限は Serverless Framework で管理せずに Terraform で管理しています。

![terraform_resources](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/05_terraform_resources.png)

### Serverless Framework の管理化リソース

Serverless Framework が管理しているリソースは API Gateway, Lambda, DynamoDB, CloudWatch Logs になります。

![serverless_framework](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/06_serverless_framework_resources.png)

## その他

ちなみにですが [AWS ハンズオン資料](https://aws.amazon.com/jp/aws-jp-introduction/aws-jp-webinar-hands-on/) に [AWS SAM を使ってテンプレートからサーバーレスな環境を構築する](https://pages.awscloud.com/event_JAPAN_Ondemand_Hands-on-for-Beginners-Serverless-2_CP.html) というハンズオン資料が既にあり SAM を使用して Infrastructure as Code（IaC）化されています。  
