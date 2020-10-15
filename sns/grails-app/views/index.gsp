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
    <h2>Grails SNS Application<h2>
</div>
</body>
</html>
