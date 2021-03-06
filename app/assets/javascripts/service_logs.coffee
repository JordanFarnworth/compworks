# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

loadingHtml = ->
  "
  <div class=\"col-md-12\">
    <i class=\"fa fa-spinner fa-pulse fa-5x\"></i>
  </div>
  "

doneLoadingHtml = ->
  "
  <div class=\"col-md-12\">
    <i style=\"color:green\" class=\"fa fa-check fa-5x\"></i>
  </div>
  "

$('.service_logs.new').ready ->
  date = new Date
  $('#client-input').autocomplete autocompleteCompanyNameParams()
  $('#date-input').val(date.toDateString())
  $('#date-input').on 'click', ->
    $('#date-input').pickadate()
  $('#sl-submit').on 'click', ->
    submitServiceLog()
  if /Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test navigator.userAgent
    $('.navbar').hide()

$('.service_logs.index').ready ->
  $('.mark-paid').on 'click', ->
    markSlAsPaid($(@).attr('data-id'))
  $('.mark-unpaid').on 'click', ->
    markSlAsUnPaid($(@).attr('data-id'))
  if /Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test navigator.userAgent
    $('.navbar').hide()


$('.service_logs.show').ready ->
  $('#client-input-edit').autocomplete autocompleteCompanyNameParams()
  getServiceLog()
  $('#sl-edit').on 'click', ->
    updateServiceLog()
  $('#sl-delete').on 'click', ->
    deleteServiceLog()
  $('#date-input-edit').on 'click', ->
    $('#date-input-edit').pickadate()
  if /Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test navigator.userAgent
    $('.navbar').hide()


markSlAsPaid = (slId) ->
  $.ajax "/api/v1/service_logs/mark_paid",
    type: 'post',
    dataType: 'json',
    data:
      id: slId
    success: (data) ->
      bootbox.alert "PO was marked as paid", ->
        location.reload()

markSlAsUnPaid = (slId) ->
  $.ajax "/api/v1/service_logs/mark_unpaid",
    type: 'post',
    dataType: 'json',
    data:
      id: slId
    success: (data) ->
      bootbox.alert "PO was marked as unpaid", ->
        location.reload()

deleteServiceLog = ->
  id = window.location.pathname.match(/\/service_logs\/(\d+)/)[1]
  bootbox.confirm "Are you sure you want to delete this service log?", (response) ->
    if response
      $.ajax "/api/v1/service_logs/#{id}",
        type: "delete"
        dataType: "json"
        success: (data) ->
          bootbox.alert "Service Log Deleted", ->
            window.location = '/service_logs'
    else
      null


getServiceLog = ->
  id = window.location.pathname.match(/\/service_logs\/(\d+)/)[1]
  $.ajax "/api/v1/service_logs/#{id}",
    type: "get"
    dataType: "json"
    success: (data) ->
      if data.payment then $('#received-payment-edit').prop('checked', true) else $('#received-payment-edit').prop('checked', false)
      $('#date-input-edit').val(new Date(data.date).toDateString())
      $('#length-input-edit').val(data.length)
      $('#notes-input-edit').val(data.notes)
      $('#client-input-edit').val(data.company)


submitServiceLog = ->
  data = buildSlRequestData()
  $('.row').addClass('text-center')
  $('#loading-space').html(loadingHtml())
  $.ajax "/api/v1/service_logs",
    type: "post",
    dataType: "json",
    contentType: false,
    processData: false,
    data: data
    success: (data) ->
      $('#loading-space').html(doneLoadingHtml())
      window.location = "/service_logs"

buildSlUpdateRequestData = ->
  formData = new FormData()
  formData.append 'service_log[date]', $('#date-input-edit').val()
  formData.append 'service_log[length]', $('#length-input-edit').val()
  formData.append 'service_log[notes]', $('#notes-input-edit').val()
  formData.append 'service_log[company_id]', $('#client-input-edit').attr('data-id')
  if $('#received-payment-edit').prop('checked') then formData.append 'service_log[payment]', true else formData.append 'service_log[payment]', false
  formData

buildSlRequestData = ->
  formData = new FormData()
  formData.append 'service_log[date]', $('#date-input').val()
  formData.append 'service_log[length]', $('#length-input').val()
  formData.append 'service_log[notes]', $('#notes-input').val()
  formData.append 'service_log[company_id]', $('#client-input').attr('data-id')
  if $('#received-payment').prop('checked') then formData.append 'service_log[payment]', true else formData.append 'service_log[payment]', false
  formData

updateServiceLog = () ->
  id = window.location.pathname.match(/\/service_logs\/(\d+)/)[1]
  data = buildSlUpdateRequestData()
  $('.row').addClass('text-center')
  $('#loading-space').html(loadingHtml())
  $.ajax "/api/v1/service_logs/#{id}",
    type: "put",
    dataType: "json",
    contentType: false,
    processData: false,
    data: data
    success: (data) ->
      $('#loading-space').html(doneLoadingHtml())
      window.location = "/service_logs"

autocompleteCompanyNameParams = ->
  {
    open: (event, ui) ->
      $('.ui-autocomplete').off('menufocus hover mouseover mouseenter')
    source:(request, response) ->
      $.ajax
        url: "/api/v1/companies",
        dataType: "json"
        data:
          search_term: request.term
        success: (data) ->
          data = $.map data, (obj, i) ->
            {label: "#{obj.name} (#{obj.doctor_name})", value: obj.id, obj: obj}
          response data

    select:(event, ui) ->
      event.preventDefault()
      id = ui.item.value
      name = ui.item.obj.name
      $(@).val(name)
      $(@).attr('data-id', id)
  }
