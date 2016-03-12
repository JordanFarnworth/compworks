# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$('.dashboard.index').ready ->
  wHeight = $(window).height()
  $('.navbar').hide()

  parallax = ->
    pHeight = $(this).outerHeight()
    pMiddle = pHeight / 2
    wMiddle = wHeight / 2
    fromTop = $(this).offset().top
    scrolled = $(window).scrollTop()
    speed = $(this).attr('data-parallax-speed')
    rangeA = fromTop - wHeight
    rangeB = fromTop + pHeight
    rangeC = fromTop - wHeight
    rangeD = pMiddle + fromTop - (wMiddle + wMiddle / 2)
    if rangeA < 0
      rangeA = 0
      rangeB = wHeight
    percent = (scrolled - rangeA) / (rangeB - rangeA)
    percent = percent * 100
    percent = percent * speed
    percent = percent.toFixed(2)
    animFromBottom = (scrolled - rangeC) / (rangeD - rangeC)
    animFromBottom = animFromBottom.toFixed(2)
    if animFromBottom >= 1
      animFromBottom = 1
    $(this).css 'background-position', 'center ' + percent + '%'
    $(this).find('.parallax-content').css 'opacity', animFromBottom
    $(this).find('.parallax-content').css 'transform', 'scale(' + animFromBottom + ')'
    return

  $('.parallax').each parallax
  $(window).scroll (e) ->
    $('.parallax').each parallax
    return
  return
