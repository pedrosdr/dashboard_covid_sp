let on = true

$(document).ready(e => {
    $('.chart-selection').parent().addClass('chart-selection-parent')

    $('#action').on('click', e => {
        if(on) {
            $('.box-evolucao-casos').fadeOut()
            $('#action').addClass('inactive')
            on = false
        }
        else {
            $('.box-evolucao-casos').fadeIn()
            $('#action').removeClass('inactive')
            on = true
        }
    })
})