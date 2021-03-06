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
//= require bootstrap-toggle
//= require turbolinks
//= require_tree .

var i = 0;

$(document).ready(function(){

	addConfigFileParamField();
	addConfigFileCSVOutputsField();
	setConfigFileDatasets();

	$("#dual-dataset-list").DualListBox();

	$("#startExperimentForm").on("submit", function(e){
		e.preventDefault();
		e.stopPropagation();

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
		$("#export_fields").toggle(500);
	});

	$("body").delegate("#notifiers_fields_button", "click", function(){
		$("#notifiers_fields").toggle(500);
	});

});

function objectifyForm(formArray) {//serialize data function

  var returnArray = {};
  for (var i = 0; i < formArray.length; i++){
    returnArray[formArray[i]['name']] = formArray[i]['value'];
  }
  return returnArray;
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

function addConfigFileParamField(){
	$(document).on('click', '.param-controls .btn-add', function(e)
    {
        e.preventDefault();

        var controlFields = $('.param-controls');
        var newControlField = $('.param-controls .form-group:last');
        controlFields.append(newControlField.clone());

        $('.param-controls .form-group .param-name-input').each(function(index){
        	$(this).attr('name', 'params[][name]');
        });
        $('.param-controls .form-group .param-value-input').each(function(index){
        	$(this).attr('name', 'params[][value]');
        });

        newControlField.find('input').val('');
        controlFields.find('.entry:not(:last) .btn-add')
            .removeClass('btn-add').addClass('btn-remove')
            .removeClass('btn-success').addClass('btn-danger')
            .html('<span class="glyphicon glyphicon-minus"></span>');
    }).on('click', '.btn-remove', function(e)
    {
		$(this).parents('.form-group:first').remove();

		e.preventDefault();

		$('.param-controls .form-group .param-name-input').each(function(index){
        	$(this).attr('name', 'params[][name]');
        });
        $('.param-controls .form-group .param-value-input').each(function(index){
        	$(this).attr('name', 'params[][value]');
        });

		return false;
	});
}

function addConfigFileCSVOutputsField(){
	$(document).on('click', '.csv-controls .btn-add', function(e)
    {
        e.preventDefault();

        var controlFields = $('.csv-controls');
        var newControlField = $('.csv-controls .form-group:last');
        controlFields.append(newControlField.clone());

        $('.csv-controls .form-group .csv-outputs-name-input').each(function(index){
        	$(this).attr('name', 'csv[outputs][][name]');
        });
        $('.csv-controls .form-group .csv-outputs-pattern-input').each(function(index){
        	$(this).attr('name', 'csv[outputs][][pattern]');
        });
        $('.csv-controls .form-group .csv-outputs-group-input').each(function(index){
        	$(this).attr('name', 'csv[outputs][][group]');
        });

        newControlField.find('input').val('');
        controlFields.find('.entry:not(:last) .btn-add')
            .removeClass('btn-add').addClass('btn-remove')
            .removeClass('btn-success').addClass('btn-danger')
            .html('<span class="glyphicon glyphicon-minus"></span>');
    }).on('click', '.btn-remove', function(e)
    {
		$(this).parents('.form-group:first').remove();

		e.preventDefault();

		$('.csv-controls .form-group .csv-outputs-name-input').each(function(index){
        	$(this).attr('name', 'csv[outputs][][name]');
        });
        $('.csv-controls .form-group .csv-outputs-pattern-input').each(function(index){
        	$(this).attr('name', 'csv[outputs][][pattern]');
        });
        $('.csv-controls .form-group .csv-outputs-group-input').each(function(index){
        	$(this).attr('name', 'csv[outputs][][group]');
        });

		return false;
	});
}

function setConfigFileDatasets(){
	$("#createConfigForm #project_id").on("change", function() {
		var project_id = this.value;

		if(project_id == -1){
			$(this).val(-1);
			return false;
		}

		$.get("/projects/"+project_id+"/datasets")
		.done(function(jsonResponse){
			$("#createConfigForm #dataset_list").next().find(".unselected").first().html("");
			for(index = 0; index < jsonResponse.length; index++){
				old_html = $("#createConfigForm #dataset_list").next().find(".unselected").first().html();
				new_html = "<option id='use_dataset_"+index+"' value='"+jsonResponse[index]["file_path"]+"'>"+jsonResponse[index]["title"]+"</option>";
				$("#createConfigForm #dataset_list").next().find(".unselected").first().html(old_html + new_html);
			};
		});
	});
}