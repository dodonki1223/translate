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

### Terraform で AWS に必要なリソースを作成する

Serverless Framework と連携するために AWS Systems Manager Parameter Store を使用する必要があるため、予め開発用のパラメータをセットしておく必要があります。  
また Terraform で環境の切り分けについてはそれぞれの環境で差異があるわけではないので Workspace を使うことを前提としています。  
dev, stg, prod の環境をそれぞれ作成しておくと良いでしょう。

注意：workspace は必ず `dev` 環境を作成しないとローカル実行もできないです！

#### workspace を作成する

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

## その他

ちなみにですが [AWS ハンズオン資料](https://aws.amazon.com/jp/aws-jp-introduction/aws-jp-webinar-hands-on/) に [AWS SAM を使ってテンプレートからサーバーレスな環境を構築する](https://pages.awscloud.com/event_JAPAN_Ondemand_Hands-on-for-Beginners-Serverless-2_CP.html) というハンズオン資料が既にあり SAM を使用して Infrastructure as Code（IaC）化されています。  
