<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="a" uri="/WEB-INF/app.tld"%>
<%@ taglib prefix="w" uri="http://www.unidal.org/web/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="res" uri="http://www.unidal.org/webres"%>
<jsp:useBean id="ctx" type="com.dianping.cat.report.page.app.Context" scope="request" />
<jsp:useBean id="payload" type="com.dianping.cat.report.page.app.Payload" scope="request" />
<jsp:useBean id="model" type="com.dianping.cat.report.page.app.Model" scope="request" />

<a:body>
	<res:useCss value="${res.css.local['select2.css']}" target="head-css" />
	<res:useCss value="${res.css.local['bootstrap-datetimepicker.min.css']}" target="head-css" />
	<res:useJs value="${res.js.local['select2.min.js']}" target="head-js" />
	<res:useJs value="${res.js.local['bootstrap-datetimepicker.min.js']}" target="head-js" />
	<res:useJs value="${res.js.local['baseGraph.js']}" target="head-js" />
	<script type="text/javascript">
		var commandInfo = ${model.command};
		function check() {
			var value = document.getElementById("checkbox").checked;

			if (value == true) {
				$('#history').slideDown();
				$("#command2").val($("#command").val());
				command2Change();
				$("#code2").val($("#code").val());
				$("#network2").val($("#network").val());
				$("#version2").val($("#version").val());
				$("#connectionType2").val($("#connectionType").val());
				$("#platform2").val($("#platform").val());
				$("#city2").val($("#city").val());
				$("#operator2").val($("#operator").val());
				$("#time2").val($("#time").val());
			} else {
				$('#history').slideUp();
			}
		}
		var command1Change = function command1Change() {
			var key = $("#command").val();
			var value = commandInfo[key];
			var code = document.getElementById("code");
			for ( var prop in value) {
				var opt = $('<option />');

				opt.html(value[prop].name);
				opt.val(value[prop].id);
				opt.appendTo(code);
			}
		}
		var command2Change = function command2Change() {
			var key = $("#command2").val();
			var value = commandInfo[key];
			var code = document.getElementById("code2");
			for ( var prop in value) {
				var opt = $('<option />');

				opt.html(value[prop].name);
				opt.val(value[prop].id);
				opt.appendTo(code);
			}
		}

		function getDate() {
			var myDate = new Date();
			var myMonth = new Number(myDate.getMonth());
			var month = myMonth + 1;
			var day = myDate.getDate();
			
			if(month<10){
				month = '0' + month;
			}
			if(day<10){
				day = '0' + day;
			}

			return myDate.getFullYear() + "-" + month + "-"
					+ myDate.getDate();
		}

		function query(field,networkCode,appVersionCode,channelCode,platformCode,cityCode,operatorCode) {
			var time = $("#time").val();
			var command = $("#command").val();
			var code = $("#code").val();
			var network = "";
			var version = "";
			var connectionType = "";
			var platform = "";
			var city = "";
			var operator = "";
			if(typeof(networkCode) == "undefined"){
				network = $("#network").val();
			}else{
				network = networkCode;
			}
			if(typeof(appVersionCode) == "undefined"){
				version = $("#version").val();
			}else{
				version = appVersionCode;
			}
			if(typeof(channelCode) == "undefined"){
				connectionType = $("#connectionType").val();
			}else{
				connectionType = channelCode;
			}
			if(typeof(platformCode) == "undefined"){
				platform = $("#platform").val();
			}else{
				platform = platformCode;
			}
			if(typeof(cityCode) == "undefined"){
				city = $("#city").val();
			}else{
				city = cityCode;
			}
			if(typeof(operatorCode) == "undefined"){
				operator = $("#operator").val();
			}else{
				operator = operatorCode;
			}
			var split = ";";
			var query1 = time + split + command + split + code + split
					+ network + split + version + split + connectionType
					+ split + platform + split + city + split + operator + split + split;;
			var query2 = "";
			var value = document.getElementById("checkbox").checked;

			if (value == true) {
				var time2 = $("#time2").val();
				var command2 = $("#command2").val();
				var code2 = $("#code2").val();
				var network2 = $("#network2").val();
				var version2 = $("#version2").val();
				var connectionType2 = $("#connectionType2").val();
				var platform2 = $("#platform2").val();
				var city2 = $("#city2").val();
				var operator2 = $("#operator2").val();
				query2 = time2 + split + command2 + split + code2 + split
						+ network2 + split + version2 + split + connectionType2
						+ split + platform2 + split + city2 + split
						+ operator2 + split + split;
			}

			var checkboxs = document.getElementsByName("typeCheckbox");
			var type = "";

			for (var i = 0; i < checkboxs.length; i++) {
				if (checkboxs[i].checked) {
					type = checkboxs[i].value;
					break;
				}
			}
			
			if(typeof(field) == "undefined"){
				field = "";
			}
			var href = "?query1=" + query1 + "&query2=" + query2 + "&type="
					+ type + "&groupByField=" + field;
			window.location.href = href;
		}

		$(document).ready(
				function() {
					$('#datetimepicker1').datetimepicker();
					$('#datetimepicker2').datetimepicker();

					var query1 = '${payload.query1}';
					var query2 = '${payload.query2}';
					var command1 = $('#command');
					var command2 = $('#command2');
					var words = query1.split(";");

					command1.on('change', command1Change);
					command2.on('change', command2Change);

					$("#command").val(words[1]);

					if (words[0] == null || words.length == 1) {
						$("#time").val(getDate());
					} else {
						$("#time").val(words[0]);
					}

					command1Change();
					$("#code").val(words[2]);
					$("#network").val(words[3]);
					$("#version").val(words[4]);
					$("#connectionType").val(words[5]);
					$("#platform").val(words[6]);
					$("#city").val(words[7]);
					$("#operator").val(words[8]);
					
					var datePair = {};
					datePair["查询1"]=$("#time").val();

					if (query2 != null && query2 != '') {
						$('#history').slideDown();
						document.getElementById("checkbox").checked = true;
						var words = query2.split(";");

						if (words[0] == null || words[0].length == 0) {
							$("#time2").val(getDate());
						} else {
							$("#time2").val(words[0]);
						}
						
						datePair["查询2"]=$("#time2").val();

						$("#command2").val(words[1]);
						command2Change();
						$("#code2").val(words[2]);
						$("#network2").val(words[3]);
						$("#version2").val(words[4]);
						$("#connectionType2").val(words[5]);
						$("#platform2").val(words[6]);
						$("#city2").val(words[7]);
						$("#operator2").val(words[8]);
					} else {
						$("#time2").val(getDate());
					}

					var checkboxs = document.getElementsByName("typeCheckbox");

					for (var i = 0; i < checkboxs.length; i++) {
						if (checkboxs[i].value == "${payload.type}") {
							checkboxs[i].checked = true;
							break;
						}
					}

					var data = ${model.lineChart.jsonString};
					graphMetricChartForApp(document
							.getElementById('${model.lineChart.id}'), data, datePair);

				});
	</script>
	
	<div class="row-fluid">
	<div class="span2">
        <div class="well sidebar-nav">
          <ul class="nav nav-list">
			<li class='nav-header active' id="all"><a href="?op=view"><strong>数据大盘</strong></a></li>
          	<li class='nav-header' id="all"><a href="?op=piechart"><strong>访问量分布</strong></a></li>
          </ul>
        </div>
	</div>
	<div class="span10">
		<%@include file="appLinechartDetail.jsp"%>
	</div>
		<table class="footer">
			<tr>
				<td>[ end ]</td>
			</tr>
		</table>
	</div>
</a:body>

<style type="text/css">
	.row-fluid .span2{
		width:10%;
	}
	.row-fluid .span10{
		width:87%;
	}
	.well {
	padding: 10px 10px 10px 19p;
	}
	.nav-list  li  a{
		padding:2px 10px;
	}
	.nav li  +.nav-header{
		margin-top:2px;
	}
	.nav-header{
		padding:15px 3px;
	}
</style>