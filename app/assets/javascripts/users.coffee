$ ->
  $('.directUpload').find("input:file").each (i, elem) ->
    fileInput    = $(elem);
    form         = $(fileInput.parents('form:first'));
    submitButton = form.find('input[type="submit"]');
    progressBar  = $("<div class='bar'></div>");
    barContainer = $("<div class='progress'></div>").append(progressBar);
    fileInput.after(barContainer);
    fileInput.fileupload
      fileInput:       fileInput,
      url:             form.data('url'),
      type:            'POST',
      autoUpload:       true,
      formData:         form.data('form-data'),
      paramName:        'file',
      dataType:         'XML',
      replaceFileInput: false,
      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10);
        progressBar.css('width', progress + '%')
      start: (e) ->
        submitButton.prop('disabled', true);

        progressBar.
        css('background', 'green').
        css('display', 'block').
        css('width', '0%').
        text("Loading...");
      done: (e, data) ->
        submitButton.prop('disabled', false);
        progressBar.text("Uploading done");

        key   = $(data.jqXHR.responseXML).find("Key").text();
        url   = '//' + form.data('host') + '/' + key;

        input = $("<input />", { type:'hidden', name: fileInput.attr('name'), value: url })
        form.append(input);
      fail: (e, data) ->
        submitButton.prop('disabled', false);

        progressBar.
        css("background", "red").
        text("Failed");
