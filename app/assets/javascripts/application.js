// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require rails-ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

var i = 0;
var exportWanted = true;
var useNotifierDefaults = false;

$(document).ready(function(){

	$("#startExperimentForm").on("submit", function(e){
		e.preventDefault();
		e.stopPropagation();

		//alert(JSON.stringify(objectifyForm($(this).serializeArray())));

		$.ajax({
		    beforeSend: function(xhrObj){
		        xhrObj.setRequestHeader("Content-Type","application/json");
		    },
		    type: "POST",
		    url: $(this).attr("action"),       
		    data: JSON.stringify(objectifyForm($(this).serializeArray())),               
		    dataType: "json",
		    success: function(json){
		       alert("Success");
		    }
		});
	});

	$("body").delegate("#export_fields_button", "click", function(){
		toggleExportFields();
	});

	$("body").delegate("#notifiers_fields_button", "click", function(){
		toggleNotifierFields();
	});

	/*$("#params_fields").html(
		'<span style="margin: 25px 0px; border-bottom: 1px solid lightgray; display: block;"><span class="field"><label for="name_' + i + '">Parameter name</label><input type="text" name="params[' + i + '][name]" id="name_' + i + '" placeholder="Type in parameter name, such as threshold"></span><span class="field"><label for="value_' + i + '">Parameter value</label><input type="text" name="params[' + i + '][value]" id="value_' + i + '" placeholder="Type in parameter value, such aus 0.5"></span></span>'
	);*/

	isOfTypeStringArr = {};

	$("body").delegate(".valueDataTypeCheckbox", "click", function(){
		isOfTypeStringArr[$(this).attr("id")] = !isOfTypeStringArr[$(this).attr("id")];
	});

	$("body").delegate("#add_param_field_button", "click", function(){
		isOfTypeStringArr["value_"+i+"_dataTypeOfValue"] = true;
		current_fields = $("#params_fields").html();
		$("#params_fields").html(current_fields + 
		'<span class="row col-xs-12"><span style="padding-left: 0;" class="form-group col-xs-5"><label for="name_' + i + '">Parameter name</label><input class="form-control" type="text" name="params[' + i + '][name]" data-param-index="' + i + '" id="name_' + i + '" placeholder="Type in parameter name, such as threshold"></span><span class="col-xs-5 form-group"><label for="value_' + i + '">Parameter value</label><input type="text" name="params[' + i + '][value]" data-param-index="' + i + '" class="form-control param_value_field" id="value_' + i + '" placeholder="Type in parameter value, such aus 0.5"></span><span class="col-xs-2 form-group valueDataTypeCheckboxWrapper" style="padding-top: 25px;"><input style="margin-right:10px;" class="valueDataTypeCheckbox" type="checkbox" id="value_'+i+'_dataTypeOfValue" value="isString" checked><label for="value_'+i+'_dataTypeOfValue">is String?</label></span></span>'); 
		i += 1;
	});

	$("#createConfigForm").on("submit", function(e){
		e.preventDefault();
		e.stopPropagation();

		conf = {"params": []};
		formArray = $(this).serializeArray();
		p = 0;
		for (var j = 0; j < formArray.length; j++){
			if(!formArray[j]['name'].includes('params'))
				conf[formArray[j]['name']] = formArray[j]['value'];
			else{
				if(formArray[j]['name'].includes('name')){
					k = j + 1;
					paramStr = '{"name": "'+formArray[j]["value"]+'", "value": '+formArray[k]["value"]+'}';
					if(isOfTypeStringArr["value_"+p+"_dataTypeOfValue"]){
						paramStr = '{"name": "'+formArray[j]["value"]+'", "value": "'+formArray[k]["value"]+'"}';
					}
					conf.params.push(JSON.parse(paramStr));
					p += 1;
				}
			}
		}

		delete conf["general_title"];
		delete conf["description"];

		setCSVExportProperties();

		$.post($("#createConfigForm").attr("action"),{conf_obj: JSON.stringify(conf), general_title: $("#general_title").val(), description: $("#description").val()},function(data){
			
		});

	});
});

function objectifyForm(formArray) {//serialize data function

  var returnArray = {};
  for (var i = 0; i < formArray.length; i++){
    returnArray[formArray[i]['name']] = formArray[i]['value'];
  }
  return returnArray;
}

function setCSVExportProperties(){
	if(exportWanted){
		conf.csvFields = conf.csvFields.split(",");
	}
	else{
		conf['csvFields'] = null;
		conf['csvFilename'] = null;
	}
}

function toggleNotifierFields(){
	useNotifierDefaults = !useNotifierDefaults;
	$("#notifiers_fields").toggle(1000);
	if(useNotifierDefaults){
		$("#notifiers_fields_button").val("Use customized notifier settings");
	}
	else{
		$("#notifiers_fields_button").val("Use default notifier settings");
	}
}

function toggleExportFields(){
	exportWanted = !exportWanted;
	$("#export_fields").toggle(1000);
	if(!exportWanted){
		$("#export_fields_button").val("Add CSV-Export");
	}
	else{
		$("#export_fields_button").val("Remove CSV-Export");
	}
}

function extractTimeoutProperties(conf){
	timeoutConf = {};

	timeoutConf['defaultTimeout'] = parseInt(conf.defaultTimeout);
	delete conf.defaultTimeout;

	timeoutConf['outputPattern'] = conf.outputPattern;
	delete conf.outputPattern;

	timeoutConf['maxTimeSinceLastStatusMsg'] = parseInt(conf.maxTimeSinceLastStatusMsg);
	delete conf.maxTimeSinceLastStatusMsg;

	return timeoutConf;
}

function extractSlackNotifier(conf){
	slackNotifierConf = {};

	slackNotifierConf['webhook_url'] = conf.webhook_url;
	delete conf.webhook_url;

	slackNotifierConf['icon'] = conf.icon;
	delete conf.icon;

	slackNotifierConf['bot_name'] = conf.bot_name;
	delete conf.bot_name;

	return slackNotifierConf;
}

function extractTelegramNotifier(conf){
	telegramNotifierConf = {};

	telegramNotifierConf['token'] = conf.token;
	delete conf.token;

	telegramNotifierConf['chat_id'] = conf.chat_id;
	delete conf.chat_id;

	return telegramNotifierConf;
}

function extractMailNotifier(conf){
	mailNotifierConf = {};

	mailNotifierConf['server'] = conf.server;
	delete conf.server;

	mailNotifierConf['user'] = conf.user;
	delete conf.user;

	mailNotifierConf['password'] = conf.password;
	delete conf.password;

	return mailNotifierConf;
}