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
		'<span class="param_pair" style="margin: 25px 0px; border-bottom: 1px solid lightgray; display: block;"><span class="field"><label for="name_' + i + '">Parameter name</label><input type="text" name="params[' + i + '][name]" data-param-index="' + i + '" id="name_' + i + '" placeholder="Type in parameter name, such as threshold"></span><span class="field"><label for="value_' + i + '">Parameter value</label><input type="text" name="params[' + i + '][value]" data-param-index="' + i + '" class="param_value_field" id="value_' + i + '" placeholder="Type in parameter value, such aus 0.5"><span class="valueDataTypeCheckboxWrapper"><input class="valueDataTypeCheckbox" type="checkbox" id="value_'+i+'_dataTypeOfValue" value="isString" checked><label for="value_'+i+'_dataTypeOfValue">is String?</label></span></span></span>'); 
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

		setCSVExportProperties();

		$.post($("#createConfigForm").attr("action"),{conf_obj: JSON.stringify(conf), general_title: $("#general_title").val(), description: $("#description").val()},function(data){
			
		});

		/*
		extractTimeoutProperties(conf);

		if(!useNotifierDefaults){
			extractSlackNotifier(conf);
			extractTelegramNotifier(conf);
			extractMailNotifier(conf);
		}

		if(!useNotifierDefaults){
			$.post("/generate_config_files",{basic_conf_obj: JSON.stringify(conf), timeout_conf_obj: JSON.stringify(timeoutConf), slack_notifier_conf_obj: JSON.stringify(slackNotifierConf), mail_notifier_conf_obj: JSON.stringify(mailNotifierConf), telegram_notifier_conf_obj: JSON.stringify(telegramNotifierConf)},function(data){
				alert(data);
			});
		}
		else{
			$.post("/generate_config_files",{basic_conf_obj: JSON.stringify(conf), timeout_conf_obj: JSON.stringify(timeoutConf), slack_notifier_conf_obj: null, mail_notifier_conf_obj: null, telegram_notifier_conf_obj: null},function(data){
				alert(data);
			});
		}	

		var url = 'data:application/json;charset=utf8,' + encodeURIComponent(JSON.stringify(conf));
		window.open(url, '_blank');

		if(!useNotifierDefaults){
			var url = 'data:application/json;charset=utf8,' + encodeURIComponent(JSON.stringify(mailNotifierConf));
			window.open(url, '_blank');

			var url = 'data:application/json;charset=utf8,' + encodeURIComponent(JSON.stringify(telegramNotifierConf));
			window.open(url, '_blank');
			
			var url = 'data:application/json;charset=utf8,' + encodeURIComponent(JSON.stringify(slackNotifierConf));
			window.open(url, '_blank');
		}*/
	});
});

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
		$("#notifiers_fields_button").val("Use default notifier settings");
	}
	else{
		$("#notifiers_fields_button").val("Use customized notifier settings");
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