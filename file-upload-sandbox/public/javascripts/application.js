function setStatus(status) {
	jQuery("#status_div").html(status);
}

function onUploadProgress(event, queueID, fileObj, data) {
	setStatus('Progress: ' + data.percentage + '%');
}

function onUploadComplete(event, queueID, fileObj, response, data) {

	// TODO: Check response success or error
	var obj = jQuery.parseJSON(response);

	$("#track_id").val(obj.track_id);
	setStatus('Upload complete! <a href=\"' + obj.track_path + '\">' + obj.track_path + '</a>');
	$("#submit").removeAttr("disabled");
	$("#file_metadata_save").css({
		'visibility': 'visible'
	});
}