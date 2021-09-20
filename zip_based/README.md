## 概要


## Lambda関数

### HelloWorldFunction
SAMのテンプレートにLambda Layerでrequestsのimportを追加したもの。

### TestFunction
自作した関数にLambda Layerでaddというオリジナルの関数を追加したもの。


## ローカル稼働

### Lambda単体での起動
sam local invoke <FunctionName>の形式で起動できる。

```
# SAMアプリケーションのディレクトリに移動
$ cd sam-app

$ sam local invoke HelloWorldFunction
{"statusCode": 200, "body": "{\"message\": \"hello world\", \"name\": \"Name\"}"}
START RequestId: 37a2ed7f-ef0a-4ef1-92fe-8f3a90116e74 Version: $LATEST
END RequestId: 37a2ed7f-ef0a-4ef1-92fe-8f3a90116e74
REPORT RequestId: 37a2ed7f-ef0a-4ef1-92fe-8f3a90116e74  Init Duration: 0.13 ms  Duration: 165.99 ms     Billed Duration: 200 ms Memory Size: 128 MB     Max Memory Used: 128 MB

$ sam local invoke TestFunction
START RequestId: bb87cba8-e782-4576-be97-3a80576c03e5 Version: $LATEST
END RequestId: bb87cba8-e782-4576-be97-3a80576c03e5
REPORT RequestId: bb87cba8-e782-4576-be97-3a80576c03e5  Init Duration: 0.30 ms  Duration: 72.63 ms      Billed Duration: 100 ms Memory Size: 128 MB     Max Memory Used: 128 MB
{"statusCode": 200, "body": "{\"message\": \"hello world\", \"name\": \"Name\", \"result\": 5}"}
```

### API Gatewayの起動

```
# APIの起動
$ sam local start-api
Mounting TestFunction at http://127.0.0.1:3000/test [GET]
Mounting HelloWorldFunction at http://127.0.0.1:3000/hello [GET]
You can now browse to the above endpoints to invoke your functions. You do not need to restart/reload SAM CLI while working on your functions, changes will be reflected instantly/automatically. You only need to restart SAM CLI if you update your AWS SAM template

# APIの呼び出し
$ curl http://127.0.0.1:3000/test
{"message": "hello world", "name": "Name", "result": 5}
```


### DynamoDBの起動

ルートディレクトリからdocker-composeで起動する。

```
docker-compose up
```

`http://localhost:8000/`でDynamoDBにアクセスできる。  
また、`http://localhost:8001/`にアクセスすればdynamodb-adminの画面にアクセスできる。



DynamoDB自体の定義はTerraformで行っているが、[DynamoDB LocalをTerraformから使う - The curse of λ](https://myuon.github.io/posts/dynanmodb-local-terraform/) を参考に設定を行い、Terraformで定義したテーブル定義が自動で作成されるようになっている。