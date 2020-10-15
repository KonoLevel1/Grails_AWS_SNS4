<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Grails SNS Application</title>
</head>
<body>
<content tag="nav">
    <li class="dropdown">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">操作<span class="caret"></span></a>
        <ul class="dropdown-menu">
            <li class="dropdown-item"><a href="/sns/send/">通知を送信</a></li>
            <li class="dropdown-item"><a href="/sns/register/">通知先を作成</a></li>
            <li class="dropdown-item"><a href="/sns/help/">ヘルプ</a></li>
        </ul>
    </li>
</content>
<g:if test="${flash.message}">
    <div class="message" role="status">${flash.message}</div>
</g:if>
<div class="center">
    <table border = "1">
    <tr>
        <th>表示内容</th>
        <th>原因</th>
    </tr>
    <tr class="table-danger">
        <td>メッセージ内容が不正です。詳細は操作タブよりHELPをご覧ください。</td>
        <td>未入力、もしくは文字数が１２文字を超えている場合に表示されます。変更したい場合は、domain>sns>Sns.groovyのconstraintsの設定を
        変更してください。AmazonSNSは通知を目的としたサービスであり、長文のメッセージは推奨されません。SNSの使用料金にご注意ください。</td>
    </tr>
    <tr class="table-danger">
        <td>メールアドレスを登録できませんでした：software.amazon.awssdk.services.sns.model.InvalidParameterException: Invalid
         parameter: Endpoint (Service: Sns, Status Code: 400, Request ID: ***)</td>
         <td>メールアドレス入力が空です。</td>
    </tr>
    <tr class="table-danger">
        <td>メールアドレスを登録できませんでした：software.amazon.awssdk.services.sns.model.InvalidParameterException: Invalid
         parameter: Email address (Service: Sns, Status Code: 400, Request ID: ***)</td>
        <td>メールアドレス以外は登録できません。</td>
    </tr>
    <tr class="table-danger">
        <td>通知を送信できませんでした：software.amazon.awssdk.services.sns.model.InvalidParameterException: Invalid
        parameter: TopicArn Reason: An ARN must have at least 6 elements, not 1 (Service: Sns, Status Code: 400, Request ID: ***)</td>
        <td>conf > application.yml の topicArnに正しい値が設定されていない可能性があります。AWSのSNSにアクセスし、トピックのARNを
        確認して設定してください。</td>
    </tr>
    </table>
</div>

</body>
</html>