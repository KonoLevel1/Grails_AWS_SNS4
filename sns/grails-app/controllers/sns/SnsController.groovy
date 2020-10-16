package sns

import grails.core.GrailsApplication

class SnsController {
    GrailsApplication grailsApplication
    def snsService

    /**
     * トップページを表示する
     */
    def index() {
        render(view: '/index.gsp')
    }

    /**
     * 通知を飛ばすページを表示する
     */
    def send() {
        String message = grailsApplication.config.getProperty('message')
        render(view: '/sns/send.gsp',model:[message:message])
    }

    /**
     * カスタムメッセージ（アプリケーションに入力したmessage）通知を飛ばす
     */
    def notificationSend(){
        String topicArn = grailsApplication.config.getProperty('topicArn')
        Sns sns = new Sns(message: params.message)
        if (sns.validate()) {
            def response = snsService.sendMessage(params.message, topicArn, params.sound1, params.badge1)
            flash.message = response
        }else{
            flash.message = "メッセージ内容が不正です。詳細は操作タブよりHELPをご覧ください。"
        }
        redirect(controller: "sns", action: "index")
    }

    /**
     * デフォルトメッセージ（Application.ymlに設定したmessage）通知を飛ばす
     */
    def defaultNotificationSend(){
        String message = grailsApplication.config.getProperty('message')
        String topicArn = grailsApplication.config.getProperty('topicArn')
        Sns sns = new Sns(message:  message)
        if (sns.validate()) {
            def response = snsService.sendMessage(message, topicArn, params.sound2, params.badge2)
            flash.message = response
        }else{
            flash.message = "メッセージ内容が不正です。詳細は操作タブよりHELPをご覧ください。"
        }
        redirect(controller: "sns", action: "index")
    }

    /**
     * メールアドレス登録ページを表示する
     */
    def register() {
        render(view: '/sns/register.gsp')
    }

    /**
     * メールアドレスをAWS-SNSのトピックに登録する
     */
    def topicRegister() {
        if (snsService.checkEmail(params.email, params.reEmail)){
            flash.message = "Emailが一致しません"
            redirect(controller: "sns", action: "register")
        }else {
            String topicArn = grailsApplication.config.getProperty('topicArn')
            def response = snsService.registerEmail(params.email, topicArn)
            flash.message = response
            redirect(controller: "sns", action: "index")
        }

    }

    /**
     * ヘルプページを表示する
     */
    def help() {
        render(view: '/sns/help.gsp')
    }
}
