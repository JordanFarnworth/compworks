# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$('.dashboard.index').ready ->
  checkForMobile()
  scaleVideoContainer()
  initBannerVideoSize '.video-container .poster img'
  initBannerVideoSize '.video-container .filter'
  initBannerVideoSize '.video-container video'
  $(window).on 'resize', ->
    scaleVideoContainer()
    scaleBannerVideoSize '.video-container .poster img'
    scaleBannerVideoSize '.video-container .filter'
    scaleBannerVideoSize '.video-container video'
    return
  return

checkForMobile = ->
  if /Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test navigator.userAgent
    alert('mobile')
  else
    alert('not')

scaleVideoContainer = ->
  height = $(window).height()
  unitHeight = parseInt(height) + 'px'
  $('.homepage-hero-module').css 'height', unitHeight
  return

initBannerVideoSize = (element) ->
  $(element).each ->
    $(this).data 'height', $(this).height()
    $(this).data 'width', $(this).width()
    return
  scaleBannerVideoSize element
  return

scaleBannerVideoSize = (element) ->
  windowWidth = $(window).width()
  windowHeight = $(window).height()
  videoWidth = undefined
  videoHeight = undefined
  console.log windowHeight
  $(element).each ->
    videoAspectRatio = $(this).data('height') / $(this).data('width')
    windowAspectRatio = windowHeight / windowWidth
    if videoAspectRatio > windowAspectRatio
      videoWidth = windowWidth
      videoHeight = videoWidth * videoAspectRatio
      $(this).css
        'top': -(videoHeight - windowHeight) / 2 + 'px'
        'margin-left': 0
    else
      videoHeight = windowHeight
      videoWidth = videoHeight / videoAspectRatio
      $(this).css
        'margin-top': 0
        'margin-left': -(videoWidth - windowWidth) / 2 + 'px'
    $(this).width(videoWidth).height videoHeight
    $('.homepage-hero-module .video-container video').addClass 'fadeIn animated'
    return
  return
