(function ($) {
  console.log('ready')

  // Give ~1/10 of a second for AJAX to return before showing loading icon
  function delayedModal() {
    var delay = 100;

    setTimeout(function() {
      if ($.active > 0) {
        $("#output").addClass("loading");
      }
    }, delay);
  }

  // Manage our little loading graphic:
  $(document).on({
    ajaxStart: delayedModal,
     ajaxStop: function() { $("#output").removeClass("loading"); }
  });

  // Run a post command if getLine function is activated with 'User generated text' as one of two choices
  // how do i do this???

  // Add line to line display (p#lines)
  function appendLine(l) {
    $("#lines").append(l + " ")
  }

  // Get response from '/displaytext' and append to displayed lines
  function getLine(event) {
    event.preventDefault();
    $.post('/displaytext', $("#chosen-books").serialize(), appendLine);
  }

  // Remove any text in the output p#lines
  function clearLines(event) {
    event.preventDefault();
    $("#lines").empty();
  }

  // Assign behavior to Submit button#get-line
  $("#get-line").click(getLine);
  // Assign behavior to Clear button#clear-lines
  $("#clear-lines").click(clearLines);

  // Clear our lines when source texts change
  $("select").on("change", clearLines);

}(jQuery));
