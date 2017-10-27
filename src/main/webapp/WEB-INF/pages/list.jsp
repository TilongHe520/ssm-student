<%--
  Created by IntelliJ IDEA.
  User: lonecloud
  Date: 2017/10/26
  Time: 下午11:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>学生界面</title>
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="page-header container ">
    <div class="row">
        <div class="col-md-12">
            <div class="col-md-4">
                <h3>学生管理系统</h3>
            </div>
            <div class="pull-right">
                <span>${user!=null?user.username:""}</span>
                <a href="${pageContext.request.contextPath}/user/logout">logout</a>
            </div>
        </div>
    </div>
</div>
<div class="container">
    <div id="toolbar" class="btn-group">
        <button id="btn_add" type="button" class="btn btn-default" onclick="add()">
            <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>新增
        </button>
        <button id="btn_edit" type="button" class="btn btn-default">
            <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>修改
        </button>
        <button id="btn_delete" type="button" class="btn btn-default" >
            <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
        </button>
    </div>
    <table id="table">
    </table>
</div>

<%--模态框--%>
<div class="modal fade" id="studentModal" tabindex="-1" role="dialog" aria-labelledby="titeLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="titeLabel">学生信息</h4>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label class="control-label" for="name">名字：</label>
                        <input type="text" class="form-control" id="name" >
                    </div>
                    <div class="form-group">
                        <label for="age-text" class="control-label">年龄:</label>
                        <input class="form-control" id="age-text"></input>
                    </div>
                    <div class="form-group">
                        <label for="major-text" class="control-label">学科:</label>
                        <input class="form-control" id="major-text"></input>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary">确定</button>
            </div>
        </div>
    </div>
</div>
</body>
<script src="${pageContext.request.contextPath}/assets/js/jquery-2.1.4.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap-table.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap-table-zh-CN.min.js"></script>
<script>
    $(function () {
        initTable();//初始化table

        function initTable() {
            $('#table').bootstrapTable({
                url: '${pageContext.request.contextPath}/student/loadListData',
                dataType: "json",
                method: 'get',                      //请求方式（*）
                toolbar: '#toolbar',                //工具按钮用哪个容器//设置左边按钮
                striped: true,                      //是否显示行间隔色
                cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
                pagination: true,                   //是否显示分页（*）
                sortable: false,                     //是否启用排序
                sortOrder: "asc",                   //排序方式
                sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
                pageNumber: 1,                       //初始化加载第一页，默认第一页
                pageSize: 10,                       //每页的记录行数（*）
                pageList: [10, 25, 50, 100],        //可供选择的每页的行数（*）
                search: true,                       //是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
                strictSearch: true,
                showColumns: true,                  //是否显示所有的列
                showRefresh: true,                  //是否显示刷新按钮
                minimumCountColumns: 2,             //最少允许的列数
                clickToSelect: true,                //是否启用点击选中行
                uniqueId: "ID",                     //每一行的唯一标识，一般为主键列
                showToggle: true,                    //是否显示详细视图和列表视图的切换按钮
                cardView: false,                    //是否显示详细视图
                detailView: false,                   //是否显示父子表
                columns: [
                    {
                        field: "checked",
                        checkbox: true,
                        title: "选择",
                        align: "center",
                        valign: "middle",
                    },
                    {
                        title: '序号',
                        field: 'id',
                        align: 'center',
                        valign: 'middle'
                    },
                    {
                        title: '名字',
                        field: 'name',
                        align: 'center',
                        valign: 'middle',
                    },
                    {
                        title: '年龄',
                        field: 'age',
                        align: 'center'
                    },
                    {
                        title: '学科',
                        field: 'major',
                        align: 'center'
                    },
                    {
                        title: '创建时间',
                        field: 'createTime',
                        align: 'center',
                    },
                    {
                        title: '操作',
                        field: 'id',
                        align: 'center',
                        formatter: function (value, row, index) {
                            var e = '<button class="btn bg-primary" onclick="edit(' + row.id + ')" data-toggle="modal" data-target="#studentModal" data-whatever="编辑">编辑</button> ';
                            var d = '<button class="btn btn-danger" onclick="del(' + row.id + ')">删除</button> ';
                            return e + d;
                        }
                    }
                ]
            });
        }
    });

    /**
     * 编辑的事件处理
     * @param id
     */
    function edit(id) {
        $.ajax({
            url:"${pageContext.request.contextPath}/student/select/"+id,
            type:"GET",
            dataType:"json",
            success:function(data){
                if(data!=null) {
                    $("#name").val(data.name);
                    $("#age-text").val(data.age);
                    $("#major-text").val(data.major);
                }
            },
            error:function(data){
                alert(data);
            }
        });
    }
    function del(id) {
        $.ajax({
            url:"${pageContext.request.contextPath}/student/delete/"+id,
            type:"GET",
            dataType:"json",
            success:function (data) {
                if(data!=null){
                    alert(data.msg);
                }
            },
            error:function (data) {
                alert("删除失败");
            }
        })
    }
</script>
</html>