package sns

class Sns {

    /**
     * 通知で表示させるメッセージ
     */
    String message


    static constraints = {
        message nullable : false, size : 1..12
    }
}
