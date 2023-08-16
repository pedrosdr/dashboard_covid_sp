let on = true

$(document).ready(e => {
    // adding page title
    $.get('../title.html', html => {
        $('section.content').before($(html))
    })

    // adding filters text
    $.get('../filters.html', html => {
        $('#sidebarCollapsed').prepend($(html))
    })

    $.get('../footer.html', html => {
        $('section.content').after($(html))
    })

    // adding chart titles
    let div_chart_title = $('<div>').addClass('chart-title').html($('<h3>'))
    $('.box-body.chart-box').before(div_chart_title)

    let boxCharts = $('.box-body').filter((i, el)=> {
        if($(el).attr('class').includes('chart-box'))
            return true
        return false
    })

    $.get('../chart-titles.txt', titles => {
        titles = titles.split('\n')

        boxCharts.each((i, el) => {
            let title = $(el).parent().find('.chart-title')
            title.html('<h3>' + titles[i] + '</h3>')
        })
    })

    // adding motion to section-title background
    $(document).on('mousemove', e => {
        let x1 = e.pageX / $('#section-title').width() * $(document).width() * 0.0005
        let y1 = e.pageY / $('#section-title').height() * $(document).height() * 0.0002
        let x2 = -e.pageX / $('#section-title').width() * $(document).width() * 0.0002
        let y2 = -e.pageY / $('#section-title').height() * $(document).height() * 0.00005
        let x3 = -e.pageX / $('#section-title').width() * $(document).width() * 0.0001
        let y3 = e.pageY / $('#section-title').height() * $(document).height() * 0.00003

        backgrounPosition = x1 + '% ' + y1 + '%, ' + x2 + '% ' + y2 + '%, ' + x3 + '% ' + y3 + '%'
        $('#section-title, #footer').css('background-position', backgrounPosition)
    })

    // adding chart-row titles
    let h2 = $('<h2>').html('<i class="fa-solid fa-angle-right"></i> Casos')
    let hr = $('<div>').addClass('hr')
    let titleDiv = $('<div>').addClass('row-title').append(h2).append(hr)

    $('.row-casos').before(titleDiv)

    h2 = $('<h2>').html('<i class="fa-solid fa-angle-right"></i> Óbitos')
    hr = $('<div>').addClass('hr')
    titleDiv = $('<div>').addClass('row-title').append(h2).append(hr)

    $('.row-obitos').before(titleDiv)

    h2 = $('<h2>').html('<i class="fa-solid fa-angle-right"></i> Casos e Óbitos')
    hr = $('<div>').addClass('hr')
    titleDiv = $('<div>').addClass('row-title').append(h2).append(hr)

    $('.row-casos-obitos').before(titleDiv)

    // adding navbar
    $.get('nav.html', html => {
        $(html).prependTo('section.content')

        // adding functionality to buttons
        $('.navbar-link').on('click', e => {
            e.preventDefault()
        })

        $('.navbar-link.link-casos').on('click', e => {
            $('html, body').animate({
                scrollTop: $('.row-casos').offset().top - 80
            },
            300)
        })

        $('.navbar-link.link-obitos').on('click', e => {
            $('html, body').animate({
                scrollTop: $('.row-obitos').offset().top - 80
            },
            300)
        })

        $('.navbar-link.link-casos-obitos').on('click', e => {
            $('html, body').animate({
                scrollTop: $('.row-casos-obitos').offset().top - 80
            },
            300)
        })
    })

    // adding scroll-top button
    $('section.content').append($('<div class="scroll-top"><i class="fa-solid fa-chevron-up"></i></div>'))

    $('.scroll-top').on('click', e => {
        $('html, body').animate({
            scrollTop: 0
        },
        300)
    })

    $(document).on('scroll', e => {
        if($(document).scrollTop() < 500) {
            $('.scroll-top').css('display', 'none')
        }
        else {
            $('.scroll-top').css('display', 'flex')
        }
    })

})

