$(document).on('turbolinks:load', function(){
    $("#initial_amount").keyup(function(e) {
        calculate_tax()
    });

    $("#tax").keyup(function(e) {
        calculate_tax()
    });
})

function calculate_tax(){
    var tax = parseFloat($('#tax').val())
    var amount = parseFloat($('#initial_amount').val())

    console.log(tax)
    console.log(amount)

    if((tax !== undefined || tax !== null) && (amount !== undefined || amount !== null) ){
        var am = ((tax / 100) * amount) + amount
        console.log(am)
        $('#actual_amount').val(am)
        console.log(am)
    }
}