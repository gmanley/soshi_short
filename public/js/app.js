$(document).ready(function () {
  $('#shrink').click(function () {
    submitUrl();
    return false;
  });
  $('#shrinkform').submit(function () {
    submitUrl();
    return false;
  });
});


function submitUrl() {
  var url_input = $('#shrinkform input:text').val();
  var prefix = 'http://';
  if (url_input.substr(0, prefix.length) !== (prefix || "https://")) {
    $('#shrinkform input:text').val(prefix + url_input);
  }

  var data = $('#shrinkform').serialize();
  $.get('/bookmark', data, function (data) {
    $('<a/>').attr('href', data).appendTo('#shrinkresult').html('<p>' + data + '</p>');
    $('#shrinkresult').fadeIn();
    $('#shrinkform input:text').val('');
  });
}