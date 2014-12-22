$(".form-control").keypress( function(event) {
  if (event.keyCode == 13) {
    $.ajax({
      url: "/weather/"+$(".form-control").val(),
      success: function (data) {
        var ctx = document.getElementById("weather-chart").getContext("2d");
        new Chart(ctx).Line(data.chart_data);
      }
    });
  }
});
