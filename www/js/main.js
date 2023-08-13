let on = true

$(document).ready(e => {
    $.get('title.html', html => {
        $('section.content').before(html)
    })

    $.get('filters.html', html => {
        $('#sidebarCollapsed').prepend(html)
    })

    $('.box .box-body.chart-selection').parent().addClass('chart-selection-parent')

    $(document).on('mousemove', e => {
        x = e.pageX / $('#section-title').width() * $(document).width() * 0.001
        y = e.pageY / $('#section-title').height() * $(document).height() * 0.001
        $('#section-title').css('background-position-x', x + '%')
        $('#section-title').css('background-position-y', y + '%')
        console.log('x: ', x, ' y: ', y)
    })
    

    $('#action').on('click', e => {
        if(on) {
            $('.box-evolucao-casos').fadeOut().width(0)
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

