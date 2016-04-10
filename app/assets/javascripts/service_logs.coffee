# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.service_logs.new').ready ->
  date = new Date
  $('#client-input').autocomplete autocompleteCompanyNameParams()
  $('#date-input').val(date.toDateString())
  $('#date-input').on 'click', ->
    $('#date-input').pickadate()
  $('#sl-submit').on 'click', ->
    submitServiceLog()

$('.service_logs.show').ready ->
  $('#client-input-edit').autocomplete autocompleteCompanyNameParams()
  getServiceLog()
  $('#sl-edit').on 'click', ->
    updateServiceLog()
  $('#date-input-edit').on 'click', ->
    $('#date-input-edit').pickadate()

getServiceLog = ->
  id = window.location.pathname.match(/\/service_logs\/(\d+)/)[1]
  $.ajax "/api/v1/service_logs/#{id}",
    type: "get"
    dataType: "json"
    success: (data) ->
      if data.payment then $('#received-payment-edit').prop('checked', true) else ('#received-payment-edit').prop('checked', false)
      $('#date-input-edit').val(new Date(data.date).toDateString())
      $('#length-input-edit').val(data.length)
      $('#sp-input-edit').val(data.service_preformed)
      $('#notes-input-edit').val(data.notes)
      $('#client-input-edit').val(data.company)


submitServiceLog = ->
  $.ajax "/api/v1/service_logs",
    type: "post"
    dataType: "json"
    data:
      service_log:
        payment: $('#received-payment-edit').prop('checked')
        date: $('#date-input-edit').val()
        length: $('#length-input-edit').val()
        service_preformed: $('#sp-input-edit').val()
        notes: $('#notes-input-edit').val()
        company_id: $('#client-input-edit').attr('data-id')
    success: (data) ->
      console.log data
      bootbox.alert "Service Log Created", ->
        window.location = "/service_logs"

updateServiceLog = () ->
  id = window.location.pathname.match(/\/service_logs\/(\d+)/)[1]
  $.ajax "/api/v1/service_logs/#{id}",
    type: "put",
    dataType: "json",
    data:
      service_log:
        payment: $('#received-payment').prop('checked')
        date: $('#date-input').val()
        length: $('#length-input').val()
        service_preformed: $('#sp-input').val()
        notes: $('#notes-input').val()
        company_id: $('#client-input').attr('data-id')
    success: (data) ->
      bootbox.alert "Service Log Updated", ->
        window.location = "/service_logs"

autocompleteCompanyNameParams = ->
  {
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
