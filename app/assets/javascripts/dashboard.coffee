# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$('.dashboard.index').ready ->
  $('.navbar-brand').hide()
  checkForMobile()

$('.dashboard.admin_dashboard').ready ->
  if /Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test navigator.userAgent
    $('.container').html(
      "
        <div class='col-md-12 text-center'>
          <br>
          <br>
          <a href='/purchase_orders/new'><h5>New Purchase Order</h5></a>
          <br>
          <a href='/purchase_orders'><h5>All Purchase Orders</h5></a>
          <br>
          <a href='/service_logs/new'><h5>New Service Log</h5></a>
          <br>
          <a href='/service_logs'><h5>All Service Logs</h5></a>
          <br>
          <a href='/companies/new'><h5>New Company</h5></a>
          <br>
          <a href='/companies'><h5>All Companies</h5></a>
        </div>
      "
    )

checkForMobile = ->
  if /Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test navigator.userAgent
    $('.homepage-hero-module').remove()
    $('.container-fluid.hidden').removeClass('hidden')
  else
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
