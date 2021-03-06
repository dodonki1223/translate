# translate ð¯ðµ â ðºð¸

ãã®ãªãã¸ããªã¯ [AWS ãã³ãºãªã³è³æ](https://aws.amazon.com/jp/aws-jp-introduction/aws-jp-webinar-hands-on/) ã® [ãµã¼ãã¼ã¬ã¹ã¢ã¼ã­ãã¯ãã£ã§ç¿»è¨³ Web API ãæ§ç¯ãã](https://pages.awscloud.com/event_JAPAN_Hands-on-for-Beginners-Serverless-2019_Contents.html) ãåèã« Terraform ã¨ Serverless Framework ã§æ¸ãç´ãããã®ã«ãªãã¾ãã  

![overall](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/00_overall.png)

## ð æ¦è¦

ãã®ãªãã¸ããªã«ã¯å¤§ããåãã¦ï¼ã¤ç®çãããä½æãã¦ãã¾ãã

- **Terraform ã¨ Serverless Framework ã®ç¸äºé£æº**
- **ãµã¼ãã¼ã¬ã¹ã¢ã¼ã­ãã¯ãã£ã¼ã® Infrastructure as Codeï¼IaCï¼å**
- **ã­ã¼ã«ã«ç°å¢ã«ã¦ãµã¼ãã¼ã¬ã¹ã¢ã¼ã­ãã¯ãã£ã¼ã®ã¨ãã¥ã¬ã¼ãããªããã®éçºãå¯è½ã«ãã**

åºæ¬çã«ã¯ãã³ãºãªã³è³æã§ä½æãããã®ã¨ã»ã¼åãã«ãªãããã«ä½æãã¦ãã¾ããä¸é¨ Lambda ã¬ã¤ã¤ã¼ãå°å¥ãã¦ãããã¨å°ãéã£ã¦ãã¾ãã  

## âï¸ ç°å¢æ§ç¯

AWS ã®ãªã½ã¼ã¹ã¯ Terraform ã§ç®¡çããã¦ãããã®ã¨ Serverless Framework ã§ç®¡çããã¦ãããã®ãããã¾ãã  
Terraform ã® tfstate ãã¡ã¤ã«ï¼ç¾å¨ã®ç¶æãè¡¨ããã¡ã¤ã«ï¼ã¯è¤æ°äººã§éçºãããã¨ãæ³å®ãã¦ãããã AWS S3 ã«ä¿å­ãã¦éçºãè¡ãã¾ãã  
ã¾ã Serverless Framework ãããã­ã¤ããããã« AWS S3 ãä½¿ç¨ããï¼CloudFormation, Lambda ã®ã³ã¼ãã zipåããããã®ãªã©ãæãã .serverless ãã©ã«ãéä¸ã«ä½æããã¦ãããã¡ã¤ã«ç¾¤ï¼ããä½æãå¿è¦ã§ãã  

S3 ã®ä½æå¾ãTerraform ã¨ Serverless Framework ã®è¨­å®ãé çªã«è¡ã£ã¦ããã¾ãã  
Terraform ã¨ Serverless Framework ã®é£æºã®ããã **è¨­å®ããé çªãã¨ã¦ãéè¦** ã«ãªã£ã¦ãã¾ãã **å¿ã Terraform ããè¨­å®ãããå¿è¦** ãããã¾ãã

### ð Terraform ã¨ Serverless Framework ã§ä½¿ç¨ãã S3 ã®ä½æ

S3 ä½æç¨ã®ã·ã§ã«ã¹ã¯ãªããããããããåºæ¬çã«ã¯ãã®ã·ã§ã«ã¹ã¯ãªãããå®è¡ããã ãã§å¤§ä¸å¤«ã§ãã  
[AWS CLI](https://docs.aws.amazon.com/ja_jp/streams/latest/dev/kinesis-tutorial-cli-installation.html) ãä½¿ç¨ãã¦ãã±ãããä½æããã®ã§ã [AWS CLI](https://docs.aws.amazon.com/ja_jp/streams/latest/dev/kinesis-tutorial-cli-installation.html) ãå®è¡ã§ããç¶æã«ãã¦ããã¦ãã ããã  
å¿ã profile ã®æå®ãå¿è¦ãªã®ã§ profile ã®ä½æãè¡ãå¿è¦ãããã¾ãã

profile ã®ä½ææ¹æ³ã«é¢ãã¦ã¯ä»¥ä¸ã®ã³ãã³ããå®è¡ãã¦ãã ããã

```shell
$ aws configure --profile terraform
```

å®éã« S3 ä½æç¨ã®ã·ã§ã«ã¹ã¯ãªãããå®è¡ããæã®ä¾ã«ãªãã¾ãã

```shell
dodonki1223ð»: ~/project/translate on ð± main [ðð¤·ââ] took 10s
ââ> bin/init_s3.sh
S3ãã±ããä½æã§ä½¿ç¨ããprofileåãå¥åãã¦ãã ãã: terraform
tfstateãããã¯Serverless Frameworkã®ããã­ã¤S3ãã±ããåãå¥åãã¦ä¸ãã: translate-sls
translate-slsã®ä½æãè¡ãã¾ã
make_bucket: translate-sls
translate-slsã«ãã¼ã¸ã§ã³ãã³ã°ãæå¹åã«æåãã¾ãã
translate-slsã«ãµã¼ãã¼å´ã®æå·åãæå¹åã«æåãã¾ãã
translate-slsã®ã¢ã¯ã»ã¹ã®å¤æ´ã«æåãã¾ãã
```

ãã®ãªãã¸ããªã§ã¯ profile åã¨ ãã±ããåã¯åºå®ã§ã½ã¼ã¹ã³ã¼ãã«æ¸ããã¦ããã®ã§é©å®å¤æ´ãã¦ãã ããã

| è¨­å®å                                  | è¨­å®å¤              |
|:----------------------------------------|:--------------------|
| AWS ã® profile å                       | terraform           |
| tfstate ã®æ ¼ç´ãã±ãã                  | translate-terraform |
| Serverless Framework ããã­ã¤ç¨ãã±ãã | terraform-sls       |

### ð­ Terraform ã®ç°å¢æ§ç¯

ã­ã¼ã«ã«ç°å¢ã§ãã£ã¦ã **Serverless Framework ã¨é£æº** ããããã« **AWS Systems Manager Parameter Store ãä½¿ç¨ããå¿è¦ããã** ãããäºãéçºç¨ã®ãã©ã¡ã¼ã¿ãã»ãããã¦ããå¿è¦ãããã¾ãã  
ãªã®ã§ Serverless Framework ã®éçºãå§ããåã«ã¾ãã¯ AWS ã«å¿è¦ãªãªã½ã¼ã¹ã Terraform ãä½¿ã£ã¦ä½æãã¦ããã¾ãã

ããããã®ä½æ¥­ã¯ **terraform ã®ãã£ã¬ã¯ããªã§è¡ã** ã®ã§å¿ãç§»åãã¦ãã ããã

```shell
$ cd translate/terraform
```

#### Terraform ãã¤ã³ã¹ãã¼ã«ãã

asdf ãªã©ã®ããã±ã¼ã¸ããã¼ã¸ã£ã¼ãä½¿ç¨ãã¦ Terraform ãã¤ã³ã¹ãã¼ã«ãã¦ä½¿ããç¶æã«ãã¾ãã

```shell
# terraform ã® plugin ãè¿½å ãã
$ asdf plugin add terraform
updating plugin repository...remote: Enumerating objects: 41, done.
remote: Counting objects: 100% (41/41), done.
remote: Compressing objects: 100% (36/36), done.
remote: Total 41 (delta 22), reused 14 (delta 5), pack-reused 0
Unpacking objects: 100% (41/41), 40.13 KiB | 334.00 KiB/s, done.
From https://github.com/asdf-vm/asdf-plugins
   8ef69e3..fe90d7a  master     -> origin/master
HEAD is now at fe90d7a feat: add asdf-gcc-arm-none-eabi plugin (#565)

# terraform ãã¤ã³ã¹ãã¼ã«ãã
$ asdf install terraform
```

#### Terraform ã®åæåã³ãã³ããå®è¡ãã

terraform åã§ä½¿ç¨ãã¦ãã plugin ãªã©ã®ãã¤ããªãã¡ã¤ã«ããã¦ã³ã­ã¼ããã¾ãã

```shell
$ terraform init 
```

#### workspace ãä½æãã

ç°å¢ã®åãåãã«ã¤ãã¦ã¯ããããã®ç°å¢ã§å·®ç°ãããããã§ã¯ãªãã®ã§ workspace ãä½¿ããã¨ãåæã¨ãã¦ãã¾ãã  
dev, stg, prod ã®ç°å¢ãããããä½æãã¦ããã¨è¯ãã§ãããã

æ³¨æï¼workspace ã¯å¿ã `dev` ç°å¢ãä½æããªãã¨ã­ã¼ã«ã«å®è¡ãã§ããªãã§ãï¼

```shell
$ terraform workspace new dev
Created and switched to workspace "dev"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
```

#### ä½æãã workspace ãé¸æãã

```shell
$ terraform workspace select dev
Switched to workspace "dev".
```

#### Terraform ã§ AWS ã®ãªã½ã¼ã¹ãä½æãã

```shell
$ terraform apply -parallelism=30
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
ã»
ã»
ã»
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
```

### ð Serverless Framework ã®ç°å¢æ§ç¯

Serverless Framework ã¯åºæ¬çã« Docker ã§éçºãè¡ããããDocker ãä½¿ããç¶æã«ãã¦ããã¦ãã ããã

ããããã®ä½æ¥­ã¯ **serverless ã®ãã£ã¬ã¯ããª** ã§è¡ãã®ã§å¿ãç§»åãã¦ãã ããã

```shell
$ cd translate/serverless
```

#### ç°å¢å¤æ°ãè¨­å®ãã

ãã³ãã¬ã¼ããã¡ã¤ã«ãã³ãã¼ãç°å¢å¤æ°ãè¨­å®ãã¾ãã

```shell
$ cp .docker/.env.sample .docker/.env
```

| ç°å¢å¤æ°å            | èª¬æ                                                                                      |
|:----------------------|:------------------------------------------------------------------------------------------|
| AWS_ACCESS_KEY_ID     | IAM ã¦ã¼ã¶ã¼ã¾ãã¯ã­ã¼ã«ã«é¢é£ä»ãããã AWS ã¢ã¯ã»ã¹ã­ã¼                                 |
| AWS_SECRET_ACCESS_KEY | AWS ã¢ã¯ã»ã¹ã­ã¼ã«é¢é£ä»ãããã¦ããã·ã¼ã¯ã¬ããã­ã¼ï¼AWS ã¢ã¯ã»ã¹ã­ã¼ã®ãã¹ã¯ã¼ãã®ãã¨ï¼|
| AWS_REGION            | profile è¨­å®ã®ãªã¼ã¸ã§ã³è¨­å®                                                              |
| DYNAMODB_LOCAL_PORT   | ã­ã¼ã«ã«ã§å®è¡ãã¦ãã DynamoDB Local ã¸ã¢ã¯ã»ã¹ããããã®ãã¼ãçªå·                      |

#### éçºç°å¢ãç«ã¡ä¸ãã

Docker ã®ã³ãã³ããå®è¡ãéçºç°å¢ãç«ã¡ä¸ãã¾ãã

```shell
$ docker-compose up
ã»
ã»
ã»
offline_1         | Server ready: http://0.0.0.0:3000 ð
```

[http://localhost:3000/dev/translate?input_text=ãã¯ãã](http://localhost:3000/dev/translate?input_text=ãã¯ãã) ã¸ã¢ã¯ã»ã¹ã `Good morning` ã¨è¿ã£ã¦ããã° API Gateway, Lambda, DynamoDB ã®ã­ã¼ã«ã«å®è¡ãåºæ¥ã¦ãã¾ãã

![translate_web_api_result](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/03_translate_web_api_result.png)

ã¾ã [http://localhost:8001](http://localhost:8001) ã«ã¢ã¯ã»ã¹ã dynamodb-admin ãè¡¨ç¤ºããã¦ãããã¨ãç¢ºèªãã¦ããã¾ãããã

![dynamodb_admin](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/04_dynamodb_admin.png)

ããã§ã­ã¼ã«ã«ã®ç°å¢æ§ç¯å®äºã§ãï¼

## âï¸ Terraform ã¨ Serverless Framework ã«ã¤ãã¦

![relationship_between_terraform_and_serverless_framework](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/01_relationship_between_terraform_and_serverless_framework.png)

éçºã«å¥ãåã«ã¾ãã¯ãã®ãªãã¸ããªã§ã® Terraform ã¨ Serverless Framework ã«ã¤ãã¦ã®èª¬æããã¾ãã  
AWS ã®ãªã½ã¼ã¹ã«é¢ãã¦ã¯ **Terraform ãç®¡çãã¦ãããã®** ã¨ **Serverless Framework ãç®¡çãã¦ãããã®** ãããã¾ãã

### ð­ Terraform ã®ç®¡çåãªã½ã¼ã¹

Terraform ãç®¡çãã¦ãããªã½ã¼ã¹ã¯ **IAM ã­ã¼ã«, ãã©ã¡ã¼ã¿ã¹ãã¢** ã«ãªãã¾ãã  
æ¨©éã¯ Serverless Framework ã§ç®¡çããã« Terraform ã§ç®¡çãã¦ãã¾ãã

![terraform_resources](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/05_terraform_resources.png)

### ð Serverless Framework ã®ç®¡çåãªã½ã¼ã¹

Serverless Framework ãç®¡çãã¦ãããªã½ã¼ã¹ã¯ **API Gateway, Lambda, DynamoDB, CloudWatch Logs** ã«ãªãã¾ãã

![serverless_framework](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/06_serverless_framework_resources.png)

### ð­ Terraform ã¨ ð Serverless Framework ã®é£æºã«ã¤ãã¦

Terraform ã¨ Serverless Framework ã®é£æºã«é¢ãã¦ã§ãã **ãTerraform â Serverless Frameworkã** ã¨ **ãServerless Framework â Terraformã** ã®ï¼ç¨®é¡ãããããããã¡ããã¨é£æºãèããªãã¨ããã¾ããã  
é£æºããããã«ããã­ã¤é ãã¡ããã¨èæ®ããå¿è¦ãããã®ã§ã©ããã£ã¦é£æºããã®ãã¨ãããã¨ã ããã¡ããã¨çè§£åºæ¥ãããã«ãªã£ã¦ããã°å¿ç¨ãããã®ã§ãã£ããã¨æ¦å¿µãé ­ã«å¥ãã¦ããã¨ããã§ãããã  

ãã®ãªãã¸ããªã§ã¯ãTerraform â Serverless Frameworkãã®é£æºã ãå®è£ããã¦ãã¾ãããã ããµã³ãã«ã¨ãã¦ãServerless Framework â Terraformããé£æºåºæ¥ããã¨ãç¢ºèªæ¸ã¿ãªã®ã§ãã¤ã§ãé£æºå¯è½ã§ãã

### ð­ Terraform â ð Serverless Framework é£æº

Serverless Framework ã®å¬å¼ãµã¤ãã« Terraform ã¨ã®é£æºæ¹æ³ã«ã¤ãã¦æ¸ããã¦ããè¨äºããããããåèã«ãã¦é£æºãã¦ãã¾ãã  
Terraform ã§ä½æãããªã½ã¼ã¹ã® arn ããã©ã¡ã¼ã¿ã¹ãã¢ã«è¨­å®ãè¨­å®ãããã©ã¡ã¼ã¿ã¹ãã¢ãã arn ãåå¾ãã¦ Serverless Framework ã§ä½¿ç¨ãã¾ãã

serverless.yml ã®ã½ã¼ã¹ã³ã¼ãä¸ã ã¨ä»¥ä¸ã®ãããªè¨è¿°ã§é£æºãã¦ãã¾ãã

```yml
custom:
  iamRoleName: ${ssm:/translate/iam_role/lambda_function_${sls:stage}}
```

è©³ããã¯ä»¥ä¸ã®è¨äºãåèã«ãã¦ãã ããã

- [The definitive guide to using Terraform with the Serverless Framework](https://www.serverless.com/blog/definitive-guide-terraform-serverless/)

### ð Serverless Framework â ð­ Terraform é£æº

Serverless Framework ã¯ CloudFormation ãä½¿ç¨ãã¦ããã­ã¤ããã®ã§ CloudFormation ãåºåãã output ãä½¿ç¨ãã¦ Terraform ã§é£æºããã¾ãã  
aws_cloudformation_export ãä½¿ç¨ãããã¨ã§ CloudFormation ãåºåããæå ±ãèª­ã¿è¾¼ããã¨ãã§ããããã«ãªãã®ã§ Terraform ã§ãé£æºãå¯è½ã«ãªãã¾ãã

```terraform 
data "aws_cloudformation_export" "lambda_function_arn" {
  name = format("lambda-function-arn-%s", terraform.workspace)
}
```

## ð» éçº

éçºã¯ Terraform ã¨ Serverless Framework ã«ãã£ã¦æ¹æ³ãéããããæ³¨æãã¦ä¸ããã  
Serverless Framework ã«é¢ãã¦ã¯è¤æ°ã®éçºæ¹æ³ããããããå¥½ã¿ã«ãã£ã¦ä½¿ãåãã¦ä¸ããã

### ð­ Terraform

éçºç°å¢ã®æ§ç¯ãçµãã£ã¦ããã°ãã®ã¾ã¾éçºãããã¨ãã§ãã¾ãã  

Terraform ã®éçºã¯ `translate/terraform` ã®ãã£ã¬ã¯ããªã«ç§»åããTerraform ã®éå¸¸éãã®éçºã¨åãã `terraform init`, `terraform plan`, `terraform apply` ãªã©ã®ã³ãã³ããä½¿ç¨ãã¦éçºãè¡ã£ã¦ä¸ããã

### ð Serverless Framework

![local_development_environment](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/02_local_development_environment.png)

Serverless Framework ã®éçºã¯ï¼éãããã¾ãã  
Docker ã®ã³ã³ããåã§éçºãããã¨ã¯å¤ãããªãã®ã§ãããVSCode ãä½¿ã£ã **[Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) ã§ã®éçº** ã¨ **éçºç¨ã®ã³ã³ããã«ã­ã°ã¤ã³ãã¦éçº** ããæ¹æ³ãããã¾ãã

Serverless Framework ã®éçºã¯ translate/serverless ã®ãã£ã¬ã¯ããªã«ç§»åãã¦éçºãè¡ãã¾ãã

#### ãªã Docker ãä½¿ã£ã¦éçºãè¡ã£ã¦ããã®ãï¼

**DynamoDB Local ã M1 Mac ã ã¨åä½ããªãã£ã** ããä»æ¹ãªã Docker åãã¦éçºãããã¨ã«ãã¾ããã
DynamoDB Local ã§ä½¿ç¨ããã¦ãã SQLLite ã®ã©ã¤ãã©ãªã arm64 ã«å¯¾å¿ãã¦ããªããã M1 Mac ã§ã®åä½ãåºæ¥ãªãããã§ãã  

ãã ç¾å¨ã§ã¯ Serverless Framework ã§ DynamoDB Local ãä½¿ç¨ãã [plugin ã Docker ã«å¯¾å¿ãã](https://github.com/99x/dynamodb-localhost/issues/63) ãã Docker åããªãã¦ãåä½ããããã«ãªã£ãï¼æªæ¤è¨¼ã§ãï¼ããããã¾ããã

#### VSCode Remote Containers

![remote_containers](https://raw.githubusercontent.com/dodonki1223/image_garage/master/translate/07_remote_containers.gif)

VSCode ã®æ¡å¼µæ©è½ã§ãã **[Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) ãäºãã¤ã³ã¹ãã¼ã«** ãã¦ããã¦ãã ããã  
gif ãè¦ãéã Remote Containers ãä½¿ç¨ã offline ã³ã³ãããèµ·åãã¦ offline ã³ã³ããåã§éçºãè¡ãã¾ãã

#### éçºç¨ã³ã³ãã

docker-compose.yml ã«éçºç¨ã®ãµã¼ãã¹ãå®ç¾©ãã¦ããã¾ãã  
`docker-compose up` ã®ã³ãã³ãã§ã¯ç«ã¡ä¸ãããªãããã« profiles ã®æå®ããã¦ããã®ã§æç¤ºçã«éçºç¨ã®ãµã¼ãã¹ãæå®ãããã¨ã§éçºç¨ã®ã³ã³ãããç«ã¡ä¸ããã¾ãã

```shell
$ docker-compose run --rm runner
```

## ð ããã­ã¤

ããã­ã¤ã¯ Terraform ã¨ Serverless Framework ã®ï¼ã¤ãããã¾ãã  
ãã®ãªãã¸ããªã§ã¯ããã­ã¤é ã¯ãããå¤§åãªãã¨ãªã®ã§ **å¿ãããã­ã¤é ãééãã** ã«è¡ãã¾ãããã

### ð¨ ããã­ã¤é ã«é¢ãã¦

**Serverless Framework ã¯ Terraform ã®ãªã½ã¼ã¹ã«ä¾å­** ãã¦ãã¾ãããªã®ã§ããã­ã¤ããæã¯ **å¿ã Terraform ããè¡ãå¿è¦** ãããã¾ãã

Serverless Framework ããããã­ã¤ãããã¨ããã¨ã¨ã©ã¼ã«ãªãå¤±æãã¾ãã

### ð ããã­ã¤ç°å¢ã«é¢ãã¦

ããã­ã¤ç°å¢ã§ãããä»¥ä¸ã®ç°å¢ãæ³å®ãã¦ä½æãã¦ããã¾ãã

| ç°å¢ | èª¬æ             |
|:----:|:-----------------|
| dev  | éçºç°å¢         |
| stg  | ã¹ãã¼ã¸ã³ã°ç°å¢ |
| prod | æ¬çªç°å¢         |

### ð­ Terraform

ã¾ãã¯ terraform ãã£ã¬ã¯ããªã«ç§»åãã¦ä¸ããã

```shell
$ cd translate/terraform
```

ããã­ã¤å¯¾è±¡ã® workspace ãé¸æãã¾ãã

```shell
$ terraform workspace select prod
Switched to workspace "prod".
```

ããã­ã¤ã³ãã³ããå®è¡ãã¾ãã

```shell
$ terraform apply -parallelism=30
```

Terraform ã«ããããã­ã¤ã¯ããã§çµäºã§ãã

### ð Serverless Framework

ã¾ãã¯ serverless ãã£ã¬ã¯ããªã«ç§»åãã¦ä¸ããã

```shell
$ cd translate/serverless
```

éçºç¨ã³ã³ãããå®è¡ãã¾ãã

```shell
$ docker-compose run --rm runner
```

ããã­ã¤ã³ãã³ããå®è¡ãã¾ãã  
`--stage xxx` ã®ãã©ã¡ã¼ã¿ãåã«ã©ã®ç°å¢ã«ããã­ã¤ããããæ±ºã¾ãã¾ãã

éçºç°å¢ã¯ã­ã¼ã«ã«å®è¡ããæã« `DYNAMODB_ENDPOINT` ã `http://localhost:${env:DYNAMODB_LOCAL_PORT}` ã«ãªãããã«ãã¦ãããããããã­ã¤æã¯æç¤ºçã« `DYNAMODB_ENDPOINT` ãæå®ãããã¨ã§ããã­ã¤ãè¡ãã¾ãã

```
# éçºç°å¢ã¸ã®ããã­ã¤
$ DYNAMODB_ENDPOINT=https://dynamodb.ap-northeast-1.amazonaws.com yarn deploy --stage dev

# ã¹ãã¼ã¸ã³ã°ç°å¢ã¸ã®ããã­ã¤
$ yarn deploy --stage stg

# æ¬çªç°å¢ã¸ã®ããã­ã¤
$ yarn deploy --stage prod
```

Serverless Framework ã«ããããã­ã¤ã¯ããã§çµäºã§ãã

## ð ãã®ä»

ã¡ãªã¿ã«ã§ãã [AWS ãã³ãºãªã³è³æ](https://aws.amazon.com/jp/aws-jp-introduction/aws-jp-webinar-hands-on/) ã« [AWS SAM ãä½¿ã£ã¦ãã³ãã¬ã¼ããããµã¼ãã¼ã¬ã¹ãªç°å¢ãæ§ç¯ãã](https://pages.awscloud.com/event_JAPAN_Ondemand_Hands-on-for-Beginners-Serverless-2_CP.html) ã¨ãããã³ãºãªã³è³æãæ¢ã«ãã SAM ãä½¿ç¨ãã¦ Infrastructure as Codeï¼IaCï¼åããã¦ãã¾ãã  
