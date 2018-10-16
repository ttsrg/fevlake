function getSum() {
  var a = $("#a").val()
  var b = $("#b").val()

  console.log("Summing: " + a + " and " + b);

  $.get("https://liquidpredator.devops.srwx.net/api/sum/?a=" + a + "&b=" + b, function( data ) {
    $("body")
      .append(" Status: " + data.Status)
      .append(" Result: " + data.Result + "<br>")
    }, "json");

}

function getDiff() {
  var a = $("#da").val()
  var b = $("#db").val()

  console.log("Difference between: " + a + " and " + b);

  $.get("https://liquidpredator.devops.srwx.net/api/diff/?a=" + a + "&b=" + b, function( data ) {
    $("body")
      .append(" Status: " + data.Status)
      .append(" Result: " + data.Result + "<br>")
    }, "json");

}
