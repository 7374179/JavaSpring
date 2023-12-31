<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
</head>
<body>
<h2>CommentTest</h2>
comment: <input type="text" name="comment"><br>
<button id="sendBtn" type="button">SEND</button>
<button id="modBtn" type="button">수정</button>
<div id="commentList"></div>
<div id="replyForm" style="display:none">
    <input type="text" name="replyComment">
    <button id="wrtRepBtn" type="button">등록</button>
</div>
<script>
    let bno = 1085

    let showList = function(bno){
        $.ajax({
            type:'GET',       // 요청 메서드
            url: '/ch4/comments?bno='+bno,  // 요청 URI
            success : function(result){
                $("#commentList").html(toHtml(result));
            },
            error   : function(){ alert("error") } // 에러가 발생했을 때, 호출될 함수
        }); // $.ajax()
    }

    $(document).ready(function() {
        showList(bno);

        $("#wrtRepBtn").click(function () {
            let comment = $("input[name=replyComment]").val();
            let pcno = $("#replyForm").parent().attr("data-pcno");

            if (comment.trim() == '') {
                alert("댓글을 입력해주세요.");
                $("input[name=replyComment]").focus()
                return;
            }

            $.ajax({
                type: 'POST',       // 요청 메서드
                url: '/ch4/comments/?bno=' + bno,  // 요청 URI
                headers: {"content-type": "application/json"},
                data: JSON.stringify({pcno: pcno, bno: bno, comment: comment}),
                success: function (result) {
                    alert(result)
                    showList(bno);
                },
                error: function () {
                    alert("error")
                } // 에러가 발생했을 때, 호출될 함수
            }); // $.ajax()        });

            $("#replyForm").css("display", "none")
            $("input[name=replyComment]").val('')
            $("#replyForm").appendTo("body");
        });

        $("#modBtn").click(function () {
            let cno = $(this).attr("data-cno");
            let comment = $("input[name=comment]").val();

            if (comment.trim() == '') {
                alert("댓글을 입력해주세요.");
                $("input[name=comment]").focus()
                return;
            }

            $.ajax({
                type: 'PATCH',       // 요청 메서드
                url: '/ch4/comments/' + cno,
                headers: {"content-type": "application/json"},
                data: JSON.stringify({cno: cno, comment: comment}),
                success: function (result) {
                    alert(result)
                    showList(bno);
                },
                error: function () {
                    alert("error")
                } // 에러가 발생했을 때, 호출될 함수
            }); // $.ajax()        });
        });

        $("#sendBtn").click(function () {
            let comment = $("input[name=comment]").val();

            if (comment.trim() == '') {
                alert("댓글을 입력해주세요.");
                $("input[name=comment]").focus()
                return;
            }

            $.ajax({
                type: 'POST',       // 요청 메서드
                url: '/ch4/comments/?bno=' + bno,  // 요청 URI
                headers: {"content-type": "application/json"},
                data: JSON.stringify({bno: bno, comment: comment}),
                success: function (result) {
                    alert(result)
                    showList(bno);
                },
                error: function () {
                    alert("error")
                } // 에러가 발생했을 때, 호출될 함수
            }); // $.ajax()        });
        });

        $("#commentList").on("click", ".replyBtn", function (){
            $("#replyForm").appendTo($(this).parent());
            $("#replyForm").css("display", "block");
        });

        $("#commentList").on("click", ".modBtn", function () {
            let cno = $(this).parent().attr("data-cno");
            let comment = $("span.comment", $(this).parent()).text();

            $("input[name=comment]").val(comment);
            $("#modBtn").attr("data-cno", cno);
        });

        // $("#delBtn").click(function(){
        $("#commentList").on("click", ".delBtn", function () {
            let cno = $(this).parent().attr("data-cno");
            let bno = $(this).parent().attr("data-bno");

            $.ajax({
                type: 'DELETE',       // 요청 메서드
                url: '/ch4/comments/' + cno + '?bno=' + bno,  // 요청 URI
                success: function (result) {
                    alert(result)
                    showList(bno);
                },
                error: function () {
                    alert("error")
                } // 에러가 발생했을 때, 호출될 함수
            }); // $.ajax()        });

        });
    });


        let toHtml = function (comments) {
            let tmp = "<ul>";

            comments.forEach(function (comment) {
                tmp += '<li data-cno=' + comment.cno
                tmp += ' data-pcno=' + comment.pcno
                tmp += ' data-bno=' + comment.bno + '>'
                if(comment.cno!=comment.pcno)
                tmp+='ㄴ'
                tmp += 'commenter=<span class="commenter">' + comment.commenter + '</span>'
                tmp += 'comment=<span class="comment">' + comment.comment + '</span>'
                tmp += 'up_date=' + comment.up_date
                tmp += '<button class="delBtn">삭제</button>'
                tmp += '<button class="modBtn">수정</button>'
                tmp += '<button class="replyBtn">답글</button>'
                tmp += '</li>'
            });

            return tmp + "</ul>";
        }

</script>
</body>
</html>